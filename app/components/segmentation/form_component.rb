class Segmentation::FormComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def initialize(segmentation = nil)
    if segmentation.nil?
      @segmentation = Segmentation.new
    else
      @segmentation = segmentation
    end
  end
end
