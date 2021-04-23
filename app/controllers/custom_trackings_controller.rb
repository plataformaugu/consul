class CustomTrackingsController < ApplicationController
  before_action :set_custom_tracking, only: [:show, :edit, :update, :destroy]

  # GET /custom_trackings
  def index
    @custom_trackings = CustomTracking.all
  end

  # GET /custom_trackings/1
  def show
  end

  # GET /custom_trackings/new
  def new
    @custom_tracking = CustomTracking.new
  end

  # GET /custom_trackings/1/edit
  def edit
  end

  # POST /custom_trackings
  def create
    @custom_tracking = CustomTracking.new(custom_tracking_params)

    if @custom_tracking.save
      redirect_to @custom_tracking, notice: 'Custom tracking was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /custom_trackings/1
  def update
    if @custom_tracking.update(custom_tracking_params)
      redirect_to @custom_tracking, notice: 'Custom tracking was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /custom_trackings/1
  def destroy
    @custom_tracking.destroy
    redirect_to custom_trackings_url, notice: 'Custom tracking was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_tracking
      @custom_tracking = CustomTracking.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def custom_tracking_params
      params.require(:custom_tracking).permit(:page, :count)
    end
end
