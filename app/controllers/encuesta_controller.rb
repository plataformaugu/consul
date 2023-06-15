class EncuestaController < ApplicationController
  before_action :set_encuestum, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  skip_authorization_check

  # GET /encuesta
  def index
    if current_user and (current_user.administrator? or current_user.moderator?)
      @encuesta = Kaminari.paginate_array(Encuestum.all.order(limit_date: :desc)).page(params[:page])
    else
      @encuesta = Kaminari.paginate_array(Encuestum.all.order(limit_date: :desc).filter{|e| e.is_visible?}).page(params[:page])
    end
  end

  # GET /encuesta/1
  def show
    if !@encuestum.is_active? and !@encuestum.results_code.present?
      if current_user and current_user.administrator?

      else
        redirect_to encuesta_path
      end
    end

    @can_participate = true
    @reason = nil

    if current_user
      if !current_user.administrator? && @encuestum.segmentation.present?
        @can_participate, @reason = @encuestum.segmentation.validate(current_user)
      end

      @code = @encuestum.code.gsub(/(?<=rut\=)(\w*)(?=\")/, current_user.document_number.insert(-2, '-'))
    end
  end

  # GET /encuesta/new
  def new
    @encuestum = Encuestum.new
  end

  # GET /encuesta/1/edit
  def edit
  end

  # POST /encuesta
  def create
    @encuestum = Encuestum.new(encuestum_params)

    if @encuestum.save
      Segmentation.generate(entity_name: @encuestum.class.name, entity_id: @encuestum.id, params: params)
      redirect_to @encuestum, notice: 'La encuesta fue creada.'
    else
      render :new
    end
  end

  # PATCH/PUT /encuesta/1
  def update
    if @encuestum.update(encuestum_params)
      Segmentation.generate(entity_name: @encuestum.class.name, entity_id: @encuestum.id, params: params)
      redirect_to @encuestum, notice: 'La encuesta fue actualizada.'
    else
      render :edit
    end
  end

  # DELETE /encuesta/1
  def destroy
    EncuestumNeighborType.where(encuestum_id: @encuestum.id).destroy_all
    @encuestum.destroy
    redirect_to encuesta_url, notice: 'La encuesta fue eliminada.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_encuestum
      @encuestum = Encuestum.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def encuestum_params
      params.require(:encuestum).permit(:name, :description, :image, :code, :main_theme_id, :limit_date, :start_date, :pdf_link, :results_code)
    end
end
