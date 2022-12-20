class Custom::CommunesSelectComponent < ApplicationComponent
  def initialize(instance, form, is_required = false)
    @instance = instance
    @form = form
    @is_required = is_required
    @communes = Commune.all
  end
end
