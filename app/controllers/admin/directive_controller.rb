class Admin::DirectiveController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :set_directive, only: [:show, :edit, :update, :destroy]
  before_action :set_layout, only: [:index]

  load_and_authorize_resource

  def new
    @neighborhood_council = NeighborhoodCouncil.find(params[:neighborhood_council_id])
    @directive = Directive.new
  end

  def create
    @directive = Directive.new(directive_params)

    if @directive.save
      redirect_to admin_neighborhood_council_path(@directive.neighborhood_council.id), notice: 'El dirigente fue creado correctamente.'
    else
      render :new
    end
  end

  def edit
    @neighborhood_council = @directive.neighborhood_council
  end

  def update
    if @directive.update(directive_params)

      redirect_to admin_neighborhood_council_path(@directive.neighborhood_council.id), notice: 'El dirigente fue actualizado correctamente.'
    else
      render :edit
    end
  end

  def destroy
    @directive.destroy!
    redirect_to admin_neighborhood_council_path(@directive.neighborhood_council.id), notice: 'El dirigente fue eliminado.'
  end

  private

    def set_directive
      @directive = Directive.find(params[:id])
    end

    def directive_params
      params.require(:directive).permit(
        :full_name,
        :position,
        :profession,
        :email,
        :phone_number,
        :neighborhood_council_id,
        :image,
        :start_date,
        :end_date
      )
    end
end
