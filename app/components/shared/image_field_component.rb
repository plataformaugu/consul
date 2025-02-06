class Shared::ImageFieldComponent < ApplicationComponent
  def initialize(instance, form, is_required = false)
    @instance = instance
    @form = form
    @is_required = is_required
  end
end
