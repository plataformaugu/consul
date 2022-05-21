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

MainTheme.create(name: 'Adulto Mayor', icon: '/images/ejes-tematicos/adultomayor.png', image: '/images/t-adultomayor.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Vida al Aire Libre', icon: '/images/ejes-tematicos/airelibre.png', image: '/images/t-parquesycerros.svg', primary_color: '#489969', secondary_color: '#397652')
MainTheme.create(name: 'Apoyo Social', icon: '/images/ejes-tematicos/apoyo-social.png', image: '/images/t-apoyosocial.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Ciclovías', icon: '/images/ejes-tematicos/ciclovias.png', image: '/images/t-ciclovia.svg', primary_color: '#489969', secondary_color: '#397652')
MainTheme.create(name: 'Cultura y Recreación', icon: '/images/ejes-tematicos/cultura-enttretencion.png', image: '/images/t-cultura.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Educación', icon: '/images/ejes-tematicos/educacion.png', image: '/images/t-educacion.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Emprendedores', icon: '/images/ejes-tematicos/emprendedores.png', image: '/images/t-emprendimiento.svg', primary_color: '#e0d276', secondary_color: '#B0A55E')
MainTheme.create(name: 'Eventos', icon: '/images/ejes-tematicos/eventos.png', image: '/images/t-grandeseventos.svg', primary_color: '#e0d276', secondary_color: '#B0A55E')
MainTheme.create(name: 'Jóvenes', icon: '/images/ejes-tematicos/jovenes.png', image: '/images/t-jovenes.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Mascotas', icon: '/images/ejes-tematicos/mascotas.png', image: '/images/t-mascotas.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Mujeres', icon: '/images/ejes-tematicos/mujeres.png', image: '/images/t-mujeres.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Salud Mental', icon: '/images/ejes-tematicos/salud-mental.png', image: '/images/t-saludmental.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Seguridad', icon: '/images/ejes-tematicos/seguridad.png', image: '/images/t-seguridad.svg', primary_color: '#c44556', secondary_color: '#9C3947')
MainTheme.create(name: 'Smart City', icon: '/images/ejes-tematicos/smartcity.png', image: '/images/t-smartcity.svg', primary_color: '#e0d276', secondary_color: '#B0A55E')
MainTheme.create(name: 'Desarrollo Sostenible', icon: '/images/ejes-tematicos/sustentabilidad.png', image: '/images/t-sustentable.svg', primary_color: '#489969', secondary_color: '#397652')
MainTheme.create(name: 'Mejor Vivienda', icon: '/images/ejes-tematicos/vivienda.png', image: '/images/t-mejorvivienda.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Nuevo Plan Regulador', icon: '/images/ejes-tematicos/planificacionurbana.png', image: '/images/t-npr.svg', primary_color: '#489969', secondary_color: '#397652')
MainTheme.create(name: 'Salud', icon: '/images/ejes-tematicos/salud.png', image: '/images/t-salud.svg', primary_color: '#4569c4', secondary_color: '#37539A')
