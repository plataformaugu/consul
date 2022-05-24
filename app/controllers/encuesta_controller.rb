class EncuestaController < ApplicationController
  before_action :set_encuestum, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  skip_authorization_check

  # GET /encuesta
  def index
    @encuesta = Kaminari.paginate_array(Encuestum.all).page(params[:page])
  end

  # GET /encuesta/1
  def show
    @can_vote = false
    @reason = 'Debes ingresar con tu cuenta para participar en esta encuesta.'

    if current_user
      if current_user.administrator?
        @can_vote = true
      elsif !@encuestum.neighbor_types.include?(current_user.neighbor_type)
        @reason = "No estás habilitado para participar. Esta encuesta es solo para #{@encuestum.neighbor_types.pluck(:name).join(', ')}."
      else
        @can_vote = true
      end
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

    params['encuestum']['neighbor_types'].each do |id|
      neighbor_type = NeighborType.find(id)
      @encuestum.neighbor_types.append(neighbor_type)
    end

    if @encuestum.save
      redirect_to @encuestum, notice: 'La encuesta fue creada.'
    else
      render :new
    end
  end

  # PATCH/PUT /encuesta/1
  def update
    if @encuestum.update(encuestum_params)
      @encuestum.neighbor_types = []

      params['encuestum']['neighbor_types'].each do |id|
        neighbor_type = NeighborType.find(id)
        @encuestum.neighbor_types.append(neighbor_type)
      end

      redirect_to @encuestum, notice: 'La encuesta fue actualizada.'
    else
      render :edit
    end
  end

  # DELETE /encuesta/1
  def destroy
    EncuestumNeighborType.where(encuestum_id: 6).destroy_all
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
      params.require(:encuestum).permit(:name, :description, :image, :code, :main_theme_id, :limit_date)
    end
end
