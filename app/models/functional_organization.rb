class FunctionalOrganization < ApplicationRecord
  belongs_to :main_theme

  def whatsapp_url
    "https://wa.me/#{self.whatsapp}"
  end

end
