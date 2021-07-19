class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]
  has_orders %w[most_voted newest oldest], only: :show
  skip_authorization_check

  # GET /quizzes
  def index
    if current_user.is_individual.nil?
      redirect_to root_path
    end
    @quizzes = Quiz.all
    redirect_to root_path
  end

  # GET /quizzes/1
  def show
    redirect_to root_path
  end

  # GET /quizzes/new
  def new
    if current_user.is_individual.nil?
      redirect_to root_path
    end
    @quiz = Quiz.new
    @title = ''
    
    if params[:type].present?
      unless ['1', '2', '3'].include? params[:type]
        redirect_to root_path
      end

      @type = params[:type].to_i
      if @type == 1
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

        unless params[:chapter].present?
          redirect_to root_path
        else
          if Tag.category.where(id: params[:chapter].to_i).exists?
            @chapter = Tag.category.find(params[:chapter].to_i)
            @title = 'Diagnósticos por tema'
            @options = get_options_by_chapter(@chapter.name)
          else
            redirect_to root_path
          end
        end
      end
      if @type == 2
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

        if params[:chapter].present?
          redirect_to root_path
        else
          @title = 'Sugerencias de mecanismos de monitoreo'
        end
      end
      if @type == 3
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

        unless params[:chapter].present?
          redirect_to root_path
        else
          if Tag.category.where(id: params[:chapter].to_i).exists?
            @chapter = Tag.category.find(params[:chapter].to_i)
            @title = 'Sugerencias de acciones por tema'
          else
            redirect_to root_path
          end
        end
      end
    else
      redirect_to root_path
    end
  end

  # GET /quizzes/1/edit
  def edit
    redirect_to root_path
  end

  # POST /quizzes
  def create
    new_params = quiz_params
    new_params['user'] = current_user

    if quiz_params['quiz_type'] == '1'
      new_params['q1'] = params['quiz']['q1'] == 'Otro' ? params['quiz']['q5'] : params['quiz']['q1']
      new_params['q2'] = params['quiz']['q2']
      new_params['q3'] = params['quiz']['q3']
      new_params['q4'] = params['q4'].present? ? params['q4'].join(', ') : ''
      new_params.delete('q5')

      if new_params['tag_id'].present? and Tag.category.exists?(id: new_params['tag_id'].to_i)
        @quiz = Quiz.new(new_params)

        if @quiz.save
          @title_text = 'Diagnóstico enviado correctamente'
          @send_text = 'Ir a la página de diagnósticos'
          @send_path = chapters_proposals_path
          @show_next_button = true
          @chapter = new_params['tag_id']
          @type = new_params['quiz_type']
          render :success
        else
          render :new
        end
      else
        render :new
      end
    elsif quiz_params['quiz_type'] == '2'
      new_params['q3'] = params['q3'].present? ? params['q3'].join(', ') : ''
      @quiz = Quiz.new(new_params)

      if @quiz.save
        @title_text = 'Sugerencia de monitoreo enviada correctamente'
        @send_text = 'Enviar otra sugerencia de monitoreo'
        @send_path = monitoring_quizzes_path
        @chapter = nil
        @type = new_params['quiz_type']
        render :success
      else
        render :new
      end
    elsif quiz_params['quiz_type'] == '3'
      @quiz = Quiz.new(new_params)

      if @quiz.save
        @title_text = 'Sugerencia de acción enviada correctamente'
        @send_text = 'Enviar otra sugerencia de acción'
        @send_path = proposals_path
        @chapter = new_params['tag_id']
        @type = new_params['quiz_type']
        render :success
      else
        render :new
      end
    else
      render :new
    end
  end

  # PATCH/PUT /quizzes/1
  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: 'Quiz was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /quizzes/1
  def destroy
    @quiz.destroy
    redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.'
  end

  def monitoring
    @quizzes = Quiz.all
    render :monitoring
  end

  def vote
    quiz_id = params['quiz_id']

    unless Vote.where(votable_type: "Quiz", votable_id: quiz_id.to_i, voter_id: current_user.id).exists?
      vote = Vote.new(votable_type: "Quiz", votable_id: quiz_id.to_i, voter_id: current_user.id, vote_weight: 1)
      vote.save
    else
      redirect root_path
    end
  end

  def is_user_allowed(quiz_type)
    count = Quiz.where(quiz_type: quiz_type).where(user_id: current_user.id).count

    if count >= 6
      return false
    else
      return true
    end
  end

  def set_invisible
    quiz_id = params['quiz_id']

    @quiz = Quiz.find(quiz_id.to_i)

    if @quiz.quiz_type == 1
      @quiz_type = 'diagnóstico'
    else
      @quiz_type = 'sugerencia'
    end

    Mailer.removed_content(@quiz.user.email, 'participación').deliver_later

    @quiz.is_active = false
    @quiz.save
  end

  def invite_user
    Mailer.user_invite(params[:email]).deliver_later
  end

  def get_options_by_chapter(chapter)
    @options = []

    if chapter.downcase == 'Memoria, verdad, justicia y reparación'.downcase
      @options = [
        'Acciones que permitan continuar la búsqueda de verdad y justicia respecto de las causas judiciales en trámite en casos desaparición forzada y ejecución política, con el objeto de cumplir con las obligaciones de investigar, juzgar y sancionar.',
        'Políticas de protección a sitios de memoria, así como de la memoria histórica, en relación con las violaciones de derechos humanos ocurridas durante la dictadura.',
        'Acciones y medidas para la búsqueda e identificación de personas detenidas desaparecidas, así como para conocer su destino final.',
        'Medidas de reparación para las víctimas de violaciones de derechos humanos durante la dictadura.',
        'Sistematización del estado de juicios y cumplimiento de sentencias en casos de violaciones de los derechos humanos ocurridas en dictadura.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Derechos Económicos, sociales, culturales y ambientales'.downcase
      @options = [
        'Derechos laborales: Brechas de género en el mercado laboral, problemas del sistema de seguridad social, empleo informal y dificultades en el ejercicio de derechos sindicales.',
        'Derechos de salud: problemas de acceso a servicios básicos, deficiencias en la calidad de la atención y falencias en infraestructura.',
        'Derecho a la educación: afectado por discriminaciones debido a causas socioeconómicas, brechas de calidad en el sistema, y problemas de infraestructura.',
        'Derecho a la vivienda: afectado por el déficit habitacional y la segregación.',
        'Derecho al agua: dificultades de acceso a servicios de agua potable y el uso no sostenible del agua.',
        'Derecho a un medio ambiente libre de contaminación: afectado por deficiencias normativas y falta de facultades de fiscalización.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Trata y tráfico de personas'.downcase
      @options = [
        'Medidas preventivas de la trata de personas.',
        'Mecanismos de protección integral a las víctimas, que les permita el ejercicio de sus derechos, especialmente en salud y acceso a la justicia.',
        'Mecanismos de identificación de víctimas de trata, por falta de un mecanismo independiente, con recursos suficientes para esta tarea.',
        'Normativa que permita investigar y sancionar todas las formas de trata y tráfico de personas, con penas efectivas y reparación integral de las víctimas.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Prevención de la tortura y violencia institucional'.downcase
      @options = [
        'Existencia de casos de tortura y otros tratos o penas crueles, inhumanos o degradantes a personas privadas de libertad en recintos penitenciarios.',
        'Existencia de casos de tortura y otros tratos o penas crueles, inhumanos o degradantes a personas internadas y bajo el cuidado del Estado, principalmente respecto de personas con discapacidad, personas mayores y niños, niñas y adolescentes.',
        'Implementación del Mecanismo Nacional de Prevención de la Tortura, como institucionalidad que contribuya a la prevención de este fenómeno.',
        'Uso de la fuerza por parte de fuerzas de orden y seguridad, con estándares internacionales de derechos humanos.',
        'Investigación, juzgamiento y sanción ante denuncias de violaciones de derechos humanos por parte de agentes del Estado, y reparación a las víctimas.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Derechos Digitales'.downcase
      @options = [
        'Regulación del uso de datos personales que realizan empresas e instituciones del Estado, con el fin de evitar poner en riesgo el derecho a la privacidad.', 
        'Regulación para el caso de la utilización de datos biométricos en casos de vigilancias ilegales y fines no consentidos.',
        'Marco normativo para evitar que el Big Data y el Data Mining generen peligro de difusión o tráfico de datos personales.',
        'Inequidad en acceso a internet o limitaciones a su uso, que generan restricciones al ejercicio de la libertad de expresión y al acceso a la información.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Acceso a la justicia'.downcase
      @options = [
        'Existencia de barreras económicas, sociales, culturales y legales que generan desigualdad ante la ley, particularmente respecto de grupos de población más vulnerable.',
        'Corporaciones de Asistencia Judicial (CAJ) requieren ampliar y mejorar su cobertura, para potenciar el acceso gratuito a servicios jurídicos.',
        'Existencia de barreras de acceso que impiden a las personas con discapacidad ejercer sus derechos ante los tribunales.',
        'Medidas de pertinencia cultural para que personas migrantes o personas de pueblos indígenas puedan ejercer de manera efectiva sus derechos ante los tribunales.',
        'Funcionamiento de los sistemas de justicia militar y de justicia civil con estándares internacionales de derechos humanos.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Personas Mayores'.downcase
      @options = [
        'Casos de maltrato contra personas mayores, tanto en residencias particulares como en establecimientos de larga estadía.',
        'Políticas públicas para que las personas mayores mantengan sus capacidades, vivan con independencia y puedan tener acceso a los cuidados que requieren.',
        'Mecanismos suficientes y adecuados para que las personas mayores puedan acceder a información relevante, considerando su menor acceso a canales digitales de difusión.',
        'Acceso a servicios sociales básicos y sistema de seguridad social que permita un bienestar material adecuado.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Mujeres'.downcase
      @options = [
        'Políticas públicas suficientes y adecuadas para prevenir y abordar integralmente la violencia en contra de las mujeres.',
        'Baja participación política y pública de mujeres, como consecuencia de obstáculos estructurales y estereotipos de género.',
        'Brechas laborales y económicas entre hombres y mujeres, expresadas en diferencias de ingreso por igual trabajo, diferencias en inserción laboral, roles de género que reproducen las desigualdades en este plano, entre otras.',
        'Vigencia de normas que imponen modelos discriminatorios contra la mujer en el matrimonio, como la administración de la sociedad conyugal.',
        'Derechos sexuales y reproductivos de las mujeres.',
        'Otro',
      ]
    end

    if chapter.downcase == 'LGBTIQ+'.downcase
      @options = [
        'Normativa, políticas y acciones que prevengan la discriminación arbitraria de  personas por su orientación sexual o identidad de género.',
        'Institucionalidad pública para la promoción y protección de los derechos de las personas LGBTIQ+, así la eliminación de barreras legales que impidan a esta población ejercer plenamente sus derechos.',
        'Visibilización y atención de la situación de los niños, niñas intersex, para garantizar sus derechos.',
        'Violencia contra la población LGBTIQ+ y políticas públicas suficientes para su prevención, sanción y abordaje.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Personas con Discapacidad'.downcase
      @options = [
        'Medidas que permitan la accesibilidad universal en infraestructura, derechos económicos y sociales, acceso a información y otras áreas.',
        'Procedimientos y acciones para hacer efectivo el acceso a la justicia de las personas con discapacidad y superación de las restricciones al ejercicio de su capacidad jurídica.',
        'Prácticas constitutivas de tortura, tratos crueles, inhumanos o degradantes en establecimientos residenciales, como: psicocirugías, tratamientos electroconvulsivos, aislamientos, tratos vejatorios, entre otros.',
        'Apoyos a las personas con discapacidad para que puedan vivir de manera independiente, con inclusión en sus comunidades.',
        'Necesidad de un sistema educativo inclusivo para personas con discapacidad.',
        'Modelo de salud con enfoque de derechos humanos.',
        'Existencia de brechas en aspectos laborales que sufren las personas con discapacidad y sus personas cuidadoras, que se refleja en barreras de acceso al trabajo y en sus niveles de ingresos.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Pueblos Indígenas y Tribales'.downcase
      @options = [
        'Uso de la fuerza por parte de agentes policiales en procedimientos investigativos al interior de comunidades indígenas, esto afecta especialmente a mujeres, niños, niñas y adolescentes y personas mayores.',
        'Protección de los territorios ancestrales indígenas.',
        'Discriminación interseccional, desigualdad y pobreza en la realización de derechos económicos, sociales y culturales.',
        'Reconocimiento constitucional de los pueblos indígenas y afrodescendientes que habitan en Chile.',
        'Necesidad de fortalecer y proteger el derecho a la participación y consulta indígena.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Personas Privadas de Libertad'.downcase
      @options = [
        'Condiciones mínimas de habitabilidad, infraestructura, equipamiento y funcionalidad de recintos penitenciarios.',
        'Existencia de prácticas que constituyen tratos crueles, inhumanos o degradantes.',
        'Precariedad de la red de salud a la que tienen acceso las personas privadas de libertad, particularmente en medicina especializada, con importantes brechas a lo largo del país.',
        'Protección de personas privadas de libertad pertenecientes a grupos especialmente vulnerables, con énfasis en mujeres, pueblos indígenas, adolescentes, entre otros.',
        'Políticas con enfoque de derecho humanos respecto de familiares y personas que visitan a las personas privadas de libertad.',
        'Sistema de justicia juvenil con estándares, recursos y mecanismos que protejan la integridad, el desarrollo y derechos de las y los adolescentes.',
        'Derecho a la educación, su calidad, oportunidad y adaptabilidad, para toda la población privada de libertad, y particularmente para adolescentes.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Personas Migrantes y Refugiadas'.downcase
      @options = [
        'Implementación de la nueva ley de migración, en particular respecto de los espacios de participación ciudadana en el nuevo Servicio, uso de los datos del Registro Nacional de Extranjeros y la forma en cómo se implementarán las visas consulares.',
        'Políticas para la protección de derechos económicos, sociales y culturales para personas migrantes, especialmente en vivienda, salud y educación, que le permitan acceder a estos derechos sin discriminación por situación migratoria.',
        'Armonización normativa, especialmente en lo relativo a la protección de protección de los trabajadores migratorios y sus familiares.',
        'Medidas para la protección de niños, niñas y adolescentes migrantes o hijos e hijas de migrantes.',
        'Acceso efectivo al procedimiento de determinación de condición de refugiado.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Niños, niñas y adolescentes'.downcase
      @options = [
        'Medidas para que niños, niñas y adolescentes que viven en centros de acogida puedan potenciar y/o mantener lazos con su entorno familiar.',
        'Acciones para la prevención, investigación y sanción de las situaciones de violencia y malos tratos contra niños, niñas y adolescentes.',
        'Brechas en sistema de asistencia sanitaria para niños, niñas y adolescentes, en materias de salud mental, rehabilitación en drogas y alcohol y educación sexual.',
        'Garantizar el derecho a educación de calidad para todos los niños, niñas y adolescentes, sin discriminación.',
        'Mecanismos de participación de niños, niñas y adolescentes, para garantizar que sean escuchados en la adopción de todas las medidas que les afecten.',
        'Medidas para erradicar el trabajo de infantil.',
        'Medidas de protección de los derechos de niños, niñas y adolescentes en procesos judiciales y un sistema especializado para su representación judicial.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Enfoque Basado en Derechos Humanos'.downcase
      @options = [
        'Canales de denuncia administrativos, que sean conocidos por la comunidad, e incidan en el desarrollo de las políticas públicas.',
        'Mecanismos de incidencia en las políticas públicas de los procesos de participación ciudadana implementados por las instituciones públicas.',
        'Espacios de participación institucional para grupos de especial protección, particularmente en los casos de niños, niñas y adolescentes, y de pueblos indígenas.',
        'Cantidad y/o calidad de la información producida por instituciones públicas, que permitan dar seguimiento a la situación de derechos humanos.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Educación en Derechos Humanos'.downcase
      @options = [
        'Incorporación de la educación en  derechos humanos en el currículo escolar.',
        'Formación y capacitación en derechos humanos para funcionarios/as del Estado, que considere aplicación práctica de contenidos y participación de estamentos directivos.',
        'Formación en derechos humanos en Fuerzas de Orden y Seguridad y Fuerzas Armadas, tanto en los procesos formativos iniciales, como en capacitaciones durante el ejercicio de sus funciones.',
        'Formación en derechos humanos en el Estado cuenta con problemas que limitan su impacto, como falta de aplicación práctica de contenidos, baja participación de estamentos directivos, entre otros.',
        'Otro',
      ]
    end

    if chapter.downcase == 'Sistemas internacionales de Derechos Humanos'.downcase
      @options = [
        'Necesidad de evaluar la ratificación, firma y retiro de reservas de tratados internacionales de derechos humanos que se encuentran pendientes.',
        'Mecanismos internos para el cumplimento de los compromisos internacionales adquiridos en los sistemas universal e interamericano de derechos humanos, así como respecto del cumplimiento de sentencias de la Corte Interamericana de Derechos Humanos.',
        'Mecanismos adecuados para que el Estado dé a conocer a la ciudadanía los tratados de derechos humanos que ha ratificado, las recomendaciones para su cumplimiento que ha recibido y el establecimiento de un mecanismo de seguimiento de las recomendaciones, con participación ciudadana.',
        'Otro',
      ]
    end

    return @options
  end

  def get_users_db
    if params[:pwd].present? and params[:pwd] == 'cocreacion'
      @filename = DateTime.now.strftime('%Y-%m-%d_%H-%m-%S_')

      csv = CSV.generate(:col_sep => ';') do |csv|
        csv << User.attribute_names
        User.find_each do |user|
          csv << user.attributes.values
        end
      end

      send_data(csv, type: 'text/csv', filename: @filename + 'DDHH.csv')
    else
      redirect_to root_path
    end
  end

  def get_quiz_type(type)
    if type === 1
      return 'Diagnóstico'
    elsif type === 2
      return 'Monitoreo'
    elsif type === 3
      return 'Sugerencia'
    end
  end

  def get_votes_by_id
    if params[:pwd].present? and params[:pwd] == 'cocreacion'
      @filename = DateTime.now.strftime('%Y-%m-%d_%H-%m-%S_')

      csv = CSV.generate(:col_sep => ';') do |csv|
        csv << ['ID', 'Tipo', 'Votos']
        Quiz.find_each do |quiz|
          csv << [quiz.id, get_quiz_type(quiz.quiz_type), quiz.votes]
        end
      end

      send_data(csv, type: 'text/csv', filename: @filename + 'votos_DDHH.csv')
    else
      redirect_to root_path
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def quiz_params
      params.require(:quiz).permit(:name, :description, :user_id, :visible, :q1, :q2, :q3, :q4, :q5, :quiz_type, :tag_id)
    end
end
