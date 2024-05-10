class Segmentation::FormComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def initialize(
    segmentation = nil,
    with_gender: true,
    with_age: true,
    with_census: true,
    with_geo: true
  )
    if segmentation.nil?
      @segmentation = Segmentation.new
    else
      @segmentation = segmentation
    end

    @sectors = Sector.all
    @with_gender = with_gender
    @with_age = with_age
    @with_census = with_census
    @with_geo = with_geo
  end
end
