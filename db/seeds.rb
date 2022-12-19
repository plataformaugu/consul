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

# Provincias
Province.create(name: 'Tocopilla', description: 'Lorem ipsum')
Province.create(name: 'El Loa', description: 'Lorem ipsum')
Province.create(name: 'Antofagasta', description: 'Lorem ipsum')

# Comunas tocopilla
Commune.create(name: 'Tocopilla', description: '', image: '/images/communes/tocopilla.jpg', province: Province.find_by(name: 'Tocopilla'))
Commune.create(name: 'María Elena', description: '', image: '/images/communes/maria-elena.jpg', province: Province.find_by(name: 'Tocopilla'))

# Comunas el loa
Commune.create(name: 'Calama', description: '', image: '/images/communes/calama.jpg', province: Province.find_by(name: 'El Loa'))
Commune.create(name: 'San Pedro de Atacama', description: '', image: '/images/communes/san-pedro.jpg', province: Province.find_by(name: 'El Loa'))
Commune.create(name: 'Ollagüe', description: '', image: '/images/communes/ollague.jpg', province: Province.find_by(name: 'El Loa'))

# Comunas antofagasta
Commune.create(name: 'Mejillones', description: '', image: '/images/communes/mejillones.jpg', province: Province.find_by(name: 'Antofagasta'))
Commune.create(name: 'Sierra Gorda', description: '', image: '/images/communes/sierra-gorda.jpg', province: Province.find_by(name: 'Antofagasta'))
Commune.create(name: 'Antofagasta', description: '', image: '/images/communes/antofagasta.jpg', province: Province.find_by(name: 'Antofagasta'))
Commune.create(name: 'Taltal', description: '', image: '/images/communes/taltal.jpg', province: Province.find_by(name: 'Antofagasta'))
