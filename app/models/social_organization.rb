class SocialOrganization < ApplicationRecord
  belongs_to :user

  validates_length_of :name, maximum: 64
  validates_length_of :description, maximum: 256

  COLUMNS_MAPPING = {
    id: 'ID',
    name: 'Nombre',
    description: 'Descripcion',
    email: 'Email',
    url: 'Pagina web',
    user_id: 'ID de Usuario',
    created_at: 'Fecha de creacion',
  }

  def self.to_csv
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << COLUMNS_MAPPING.values()

      all.each do |social_organization|
        csv << COLUMNS_MAPPING.keys().map{ |column| social_organization.send(column) }
      end
    end
  end
end
