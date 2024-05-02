# Default admin user (change password after first deploy to a server!)
if Administrator.count == 0 && !Rails.env.test?
  admin = User.create!(username: "admin", email: "admin@consul.dev", password: "12345678",
                       password_confirmation: "12345678", confirmed_at: Time.current,
                       terms_of_service: "1")
  admin.create_administrator
end

Setting.reset_defaults
load Rails.root.join("db", "web_sections.rb")

# Default custom pages
load Rails.root.join("db", "pages.rb")

# Sustainable Development Goals
load Rails.root.join("db", "sdg.rb")

Sector.create(internal_id: 1, name: 'Los Trapenses')
Sector.create(internal_id: 2, name: 'La Dehesa')
Sector.create(internal_id: 3, name: 'Jardines de la Dehesa')
Sector.create(internal_id: 4, name: 'La Dehesa Antigua')
Sector.create(internal_id: 5, name: 'El Huinganal')
Sector.create(internal_id: 6, name: 'Pueblo Lo Barnechea')
Sector.create(internal_id: 7, name: 'Las Lomas')
Sector.create(internal_id: 8, name: 'Ermita de San Antonio')
Sector.create(internal_id: 9, name: 'Avenida Las Condes - San Enrique')
Sector.create(internal_id: 10, name: 'Villa el Rodeo')
Sector.create(internal_id: 11, name: 'Villa Cerro 18')
Sector.create(internal_id: 12, name: 'Cerro 18 Norte')
Sector.create(internal_id: 13, name: 'Cerro 18 Sur')
Sector.create(internal_id: 14, name: 'El Arrayán')
Sector.create(internal_id: 15, name: 'Camino a Farellones')
Sector.create(internal_id: 16, name: 'Centro de Montaña')
