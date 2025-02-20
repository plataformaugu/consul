class SurveysController < ApplicationController
  include TarjetaVecino
  include LasCondesAPI
  include FeatureFlags
  include CommentableActions
  include HasOrders
  include ActsAsParanoidAliases

  before_action :set_survey, only: [:show, :edit, :update, :destroy, :pending, :send_answers, :participate_manager_form, :participate_manager_existing_user, :participate_manager_new_user, :results]

  load_and_authorize_resource

  has_orders %w[oldest], only: [:show, :edit]

  def pending; end

  # GET /surveys
  def index
    @type = params[:type]

    if ![Survey::TYPE_SURVEY, Survey::TYPE_POLL].include?(@type)
      redirect_to root_path
    end

    @surveys = Kaminari.paginate_array(Survey.published.where(survey_type: @type).order(created_at: :desc)).page(params[:page])
  end

  def results
    @results = {
      "answers_count" => 0,
      "items" => [],
    }
    @stats = {
      "total_male_participants" => 0,
      "total_female_participants" => 0,
      "total_other_participants" => 0,
      "participants_by_age" => [],
    }

    if @survey.is_expired?
      survey_answers = Survey.joins(items: :answers).where(id: @survey.id)
      user_ids = survey_answers.pluck('user_id').uniq
      users = User.where(id: user_ids)
      users_count = users.count
      users_male_count = users.male.count
      users_female_count = users.female.count
      users_other_count = users_count - users_male_count - users_female_count

      @results["answers_count"] = user_ids.count
      @results["items"] = @survey.items.where(
        item_type: [
          Survey::Item::ITEM_TYPE_UNIQUE,
          Survey::Item::ITEM_TYPE_MULTIPLE,
          Survey::Item::ITEM_TYPE_RANKING
        ]
      )
      @stats["total_male_participants"] = users_male_count
      @stats["total_female_participants"] = users_female_count
      @stats["total_other_participants"] = users_other_count
      @stats["participants_by_age"] = age_groups.to_h do |start, finish|
        count = users.between_ages(start, finish).count
  
        [
          "#{start} - #{finish}",
          {
            range: range_description(start, finish),
            count: count,
            percentage: PercentageCalculator.calculate(count, users_count)
          }
        ]
      end
    end
  end

  # GET /surveys/1
  def show
    @results = {
      "answers_count" => 0,
      "items" => [],
    }
    @stats = {
      "total_male_participants" => 0,
      "total_female_participants" => 0,
      "total_other_participants" => 0,
      "participants_by_age" => [],
    }

    @commentable = @survey
    @comment_tree = CommentTree.new(@commentable, params[:page], @current_order)

    @can_participate = true
    @reason = nil

    if @survey.segmentation.present?
      @can_participate, @reason = @survey.segmentation.validate(current_user)
    end

    if @survey.is_expired?
      survey_answers = Survey.joins(items: :answers).where(id: @survey.id)
      user_ids = survey_answers.pluck('user_id').uniq
      users = User.where(id: user_ids)
      users_count = users.count
      users_male_count = users.male.count
      users_female_count = users.female.count
      users_other_count = users_count - users_male_count - users_female_count

      @results["answers_count"] = user_ids.count
      @results["items"] = @survey.items.where(
        item_type: [
          Survey::Item::ITEM_TYPE_UNIQUE,
          Survey::Item::ITEM_TYPE_MULTIPLE,
          Survey::Item::ITEM_TYPE_RANKING
        ]
      )
      @stats["total_male_participants"] = users_male_count
      @stats["total_female_participants"] = users_female_count
      @stats["total_other_participants"] = users_other_count
      @stats["participants_by_age"] = age_groups.to_h do |start, finish|
        count = users.between_ages(start, finish).count
  
        [
          "#{start} - #{finish}",
          {
            range: range_description(start, finish),
            count: count,
            percentage: PercentageCalculator.calculate(count, users_count)
          }
        ]
      end
    end
  end

  def send_answers
    prepared_answers = get_prepared_answers(@survey, params)

    if prepared_answers.nil?
      flash[:alert] = "Debes completar todos los campos obligatorios."
      render :show
      return
    end

    if params.has_key?(:manager_confirm)
      @prepared_answers = prepared_answers
      @comunas = get_comunas
      render :participate_manager_form
      return
    end

    save_answers(prepared_answers, current_user)

    redirect_to survey_path(@survey.id), notice: "Las respuestas se registraron correctamente."
  end

  def participate_manager_form
  end

  def participate_manager_existing_user
    prepared_answers = JSON.parse(params[:prepared_answers])
    user_id = params[:user_id]

    if user_id.nil?
      flash[:error] = "Ocurrió un error inesperado. Vuelve a intentarlo."
      redirect_to survey_path(@survey.id)
      return
    end

    existing_user = User.find(user_id)

    if @survey.answered_by_user?(existing_user)
      flash[:error] = "Este usuario ya respondió la encuesta."
      redirect_to survey_path(@survey.id)
      return
    end

    save_answers(prepared_answers, existing_user)

    flash[:notice] = "Se respondió la encuesta en nombre de: #{existing_user.full_name}"
    redirect_to survey_path(@survey.id)
  end

  def participate_manager_new_user
    prepared_answers = JSON.parse(params[:user][:prepared_answers])
    clean_document_number = params[:user][:document_number].gsub(/[^a-z0-9]+/i, "").upcase

    if User.exists?(document_number: clean_document_number)
      flash[:error] = "Ya existe un usuario registrado con el RUT: #{clean_document_number}."
      redirect_to survey_path(@survey.id)
      return
    end

    if !params[:user][:email].empty? and User.exists?(email: params[:user][:email])
      flash[:error] = "Ya existe un usuario registrado con el email: #{params[:user][:email]}"
      redirect_to survey_path(@survey.id)
      return
    end

    clean_document_number_with_dash = "#{clean_document_number.chop}-#{clean_document_number[-1]}"

    born_data = registro_civil_request(clean_document_number_with_dash, 'certificado-nacimiento')

    if born_data.nil? || born_data.empty? || born_data == {}
      redirect_to survey_path(@survey.id), alert: "No se encontró una persona ligada al RUT ingresado."
      return
    end

    profession_data = registro_civil_request(clean_document_number_with_dash, 'informacion-profesion')
    home_data = registro_civil_request(clean_document_number_with_dash, 'informacion-domicilio')

    born_data = !born_data.nil? ? born_data.fetch('CertificadoNacimiento', {}) : {}
    profession_data = !profession_data.nil? ? profession_data.fetch('datosPersona', {}).fetch('datosProfesion', {}) : {}
    home_data = !home_data.nil? ? home_data.fetch('datoPersona', {}) : {}

    permitted_params = params.require(:user).permit(
      :document_number,
      :email,
      :gender,
      :phone_number,
      :comuna,
      :address,
      :house_type,
      :house_reference,
      :education,
    ).merge(
      document_number: clean_document_number,
      email: params[:user][:email].empty? ? "manager_user_#{clean_document_number}@ugu.cl" : params[:user][:email],
    )

    new_user = User.new(permitted_params)

    new_user.first_name = born_data.fetch('Nombre', {}).fetch('nombres', '').titleize
    new_user.last_name = born_data.fetch('Nombre', {}).fetch('apellidoPaterno', '').titleize
    new_user.maiden_name = born_data.fetch('Nombre', {}).fetch('apellidoMaterno', '').titleize
    new_user.date_of_birth = !born_data.fetch('fechaNacimiento', nil).nil? ? Date.strptime(born_data['fechaNacimiento'], '%Y-%m-%d') : nil
    new_user.civil_status = home_data.fetch('estadoCivil', nil),
    new_user.nationality = born_data.fetch('nacionalidadNacimiento', '').titleize,
    new_user.profession = (profession_data.is_a?(Hash) && !profession_data.fetch('tituloProfesional', nil).nil?) ? profession_data['tituloProfesional'].titleize : nil

    if new_user.first_name.empty? || new_user.last_name.empty?
      redirect_to survey_path(@survey.id), alert: "No se encontró una persona ligada al RUT ingresado."
      return
    end

    tarjeta_vecino_data = get_tarjeta_vecino_data(new_user.document_number)
    new_user.neighbor_type_id = tarjeta_vecino_data[:neighbor_type].id

    if tarjeta_vecino_data[:has_tarjeta_vecino]
      new_user.has_tarjeta_vecino = true

      if tarjeta_vecino_data[:is_tarjeta_vecino_active]
        new_user.is_tarjeta_vecino_active = true
        new_user.tarjeta_vecino_code = tarjeta_vecino_data[:tarjeta_vecino_code]
        new_user.tarjeta_vecino_start_date = tarjeta_vecino_data[:tarjeta_vecino_start_date]
      end
    end

    if !params['alt-street'].empty?
      new_user.address = "#{params['alt-street']} #{params['alt-number']}"
      sector_data = get_sector_data("#{params['alt-street']} #{params['alt-number']}")

      if !sector_data.nil?
        new_user.sector = Sector.where(name: "C#{sector_data['sector']}").first
        new_user.lat = sector_data['lat'].gsub(',', '.').to_f
        new_user.long = sector_data['long'].gsub(',', '.').to_f

        if new_user.comuna == 'Las Condes'
          send_user_data_to_neighborhood_directory(
            new_user,
            sector_data['id']
          )
          new_user.id_direccion = sector_data['id'].to_i
        end
      end
    end

    new_user.save(validate: false)

    save_answers(prepared_answers, new_user)

    flash[:notice] = "Se respondió la encuesta en nombre de: #{new_user.full_name}"
    redirect_to survey_path(@survey.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def survey_params
      params.require(:survey).permit(:title, :body, :image)
    end

    def get_prepared_answers(survey, params)
      prepared_answers = []

      survey.items.each do |survey_item|
        current_answer = params["survey_item_#{survey_item.id}"]
  
        if survey_item.item_type == Survey::Item::ITEM_TYPE_RANKING
          current_answer = current_answer.split(',').map{ |value| value.strip }
        elsif survey_item.required && survey_item.item_dependency_id.nil?
          if !params.key?("survey_item_#{survey_item.id}")
            return nil
          else
            if current_answer.instance_of?(Array) and current_answer.empty?
              return nil
            elsif current_answer.instance_of?(String) and current_answer.strip.empty?
              return nil
            end
          end
        end
  
        prepared_answers.push([survey_item.id, current_answer.nil? ? [] : current_answer])
      end

      return prepared_answers
    end

    def save_answers(prepared_answers, user)
      prepared_answers.each do |prepared_answer|
        Survey::Item::Answer.create(
          survey_item_id: prepared_answer[0],
          data: prepared_answer[1],
          user: user
        )
      end
    end

    def age_groups
      [[16, 19],
       [20, 24],
       [25, 29],
       [30, 34],
       [35, 39],
       [40, 44],
       [45, 49],
       [50, 54],
       [55, 59],
       [60, 64],
       [65, 69],
       [70, 74],
       [75, 79],
       [80, 84],
       [85, 89],
       [90, 300]
      ]
    end

    def range_description(start, finish)
      if finish > 200
        I18n.t("stats.age_more_than", start: start)
      else
        I18n.t("stats.age_range", start: start, finish: finish)
      end
    end
    
    def get_comunas
      comunas = JSON.parse(File.read(File.join(File.dirname(__FILE__), 'comunas.json')))
      comunas = comunas.pluck('name')
      comunas.delete('Las Condes')
      comunas.sort
      comunas.insert(0, 'Las Condes')
  
      return comunas
    end

    def validate_clave_unica_response(code)
      @secret = Rails.application.secrets.clave_unica_secret
      @code = code
      result = clave_unica_request
      found_user = User.with_deleted.where(document_number: result['rut'].gsub(/[^0-9a-z ]/i, '')).first

      return {
        data: result,
        found_user: found_user
      }
    end


    def registro_civil_request(rut, type)
      begin
        uri = URI("https://bus-datos.lascondes.cl/api/srcei/#{type}/")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        request["Authorization"] = "Bearer A8Vq8HmOepf38i38i7D95RkF3kxhmeSOVlItK4rFim12tK4rFim12diVun3aHe9k9Ll0"
        request.body = JSON.dump({
          "rut": rut.split('-')[0],
          "dv": rut.split('-')[1]
        })
        response = https.request(request)
        result = JSON.parse(response.body)
        return result
      rescue
        return nil
      end
    end

    def get_sector_data(address)
      uri = URI("https://bus-datos.lascondes.cl/api/maestros/direcciones/direccion-like")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request["Authorization"] = "Bearer A8Vq8HmOepf38i38i7D95RkF3kxhmeSOVlItK4rFim12tK4rFim12diVun3aHe9k9Ll0"
      request.body = JSON.dump({
        "q": address,
      })
      response = https.request(request)
  
      begin
        if response.kind_of? Net::HTTPSuccess
          result = JSON.parse(response.body)['result']
  
          if result.empty?
            return nil
          else
            sector_data = result[0]
            return {
              "sector" => sector_data['cod_unidadvecinal'],
              "lat" => sector_data['str_latitud'],
              "long" => sector_data['str_longitud'],
              "id" => sector_data['id']
            }
          end
        else
          return nil
        end
      rescue
        return nil
      rescue Exception
        return nil
      end
    end
end
