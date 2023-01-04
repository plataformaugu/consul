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
Province.create(name: 'Tocopilla', description: 'La provincia de Tocopilla se ubica al norte de la región de Antofagasta. Tiene una superficie de 16.385,2 km² y posee una población de 31.643 habitantes. Las comunas que la componen son Tocopilla (capital), conocida como la capital de la energía y María Elena, la última oficina salitrera del mundo.')
Province.create(name: 'El Loa', description: 'La provincia de El Loa se ubica al oriente de la región de Antofagasta. Tiene una superficie de 42.934,1 km² y posee una población de 177.048 habitantes. Las comunas que la componen son Calama (capital), donde se ubica uno de los minerales más importantes del país; además de San Pedro de Atacama (que destaca por su gran atractivo turístico) y Ollagüe, comuna ubicada a 3.660 metros de altura.')
Province.create(name: 'Antofagasta', description: 'La provincia de Antofagasta se ubica al poniente de la región. Tiene una superficie de 65.987 km² (siendo el territorio más extenso de la región) y posee una población de 398.843 habitantes. La componen las comunas de Antofagasta (capital), Sierra Gorda, Mejillones y Taltal.')

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
