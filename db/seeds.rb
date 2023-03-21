Setting.reset_defaults
load Rails.root.join("db", "web_sections.rb")

# Default custom pages
load Rails.root.join("db", "pages.rb")

# Sustainable Development Goals
load Rails.root.join("db", "sdg.rb")


(1..6).each do |n|
    MacroTerritory.create(name: "MT-0#{n}")
end

(1..25).each do |n|
    Sector.create(name: "C#{n}")
end

MacroTerritory.find_by(name: 'MT-01').sectors << Sector.find_by(name: 'C20')
MacroTerritory.find_by(name: 'MT-01').sectors << Sector.find_by(name: 'C24')
MacroTerritory.find_by(name: 'MT-01').sectors << Sector.find_by(name: 'C25')
MacroTerritory.find_by(name: 'MT-01').sectors << Sector.find_by(name: 'C21')

MacroTerritory.find_by(name: 'MT-02').sectors << Sector.find_by(name: 'C1')
MacroTerritory.find_by(name: 'MT-02').sectors << Sector.find_by(name: 'C2')
MacroTerritory.find_by(name: 'MT-02').sectors << Sector.find_by(name: 'C10')
MacroTerritory.find_by(name: 'MT-02').sectors << Sector.find_by(name: 'C18')

MacroTerritory.find_by(name: 'MT-03').sectors << Sector.find_by(name: 'C3')
MacroTerritory.find_by(name: 'MT-03').sectors << Sector.find_by(name: 'C4')
MacroTerritory.find_by(name: 'MT-03').sectors << Sector.find_by(name: 'C5')
MacroTerritory.find_by(name: 'MT-03').sectors << Sector.find_by(name: 'C6')
MacroTerritory.find_by(name: 'MT-03').sectors << Sector.find_by(name: 'C7')
MacroTerritory.find_by(name: 'MT-03').sectors << Sector.find_by(name: 'C8')

MacroTerritory.find_by(name: 'MT-04').sectors << Sector.find_by(name: 'C13')
MacroTerritory.find_by(name: 'MT-04').sectors << Sector.find_by(name: 'C14')
MacroTerritory.find_by(name: 'MT-04').sectors << Sector.find_by(name: 'C15')
MacroTerritory.find_by(name: 'MT-04').sectors << Sector.find_by(name: 'C16')

MacroTerritory.find_by(name: 'MT-05').sectors << Sector.find_by(name: 'C11')
MacroTerritory.find_by(name: 'MT-05').sectors << Sector.find_by(name: 'C12')
MacroTerritory.find_by(name: 'MT-05').sectors << Sector.find_by(name: 'C17')
MacroTerritory.find_by(name: 'MT-05').sectors << Sector.find_by(name: 'C19')

MacroTerritory.find_by(name: 'MT-06').sectors << Sector.find_by(name: 'C9')
MacroTerritory.find_by(name: 'MT-06').sectors << Sector.find_by(name: 'C22')
MacroTerritory.find_by(name: 'MT-06').sectors << Sector.find_by(name: 'C23')

NeighborType.create(name: 'Vecino Residente Las Condes')
NeighborType.create(name: 'Vecino Flotante Las Condes')
NeighborType.create(name: 'Registrado sin Tarjeta Vecino')

MainTheme.create(name: 'Adulto Mayor', icon: '/images/ejes-tematicos/adultomayor.png', image: '/images/t-adultomayor.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Vida al Aire Libre', icon: '/images/ejes-tematicos/airelibre.png', image: '/images/t-parquesycerros.svg', primary_color: '#286340', secondary_color: '#397652')
MainTheme.create(name: 'Apoyo Social', icon: '/images/ejes-tematicos/apoyo-social.png', image: '/images/t-apoyosocial.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Ciclovías', icon: '/images/ejes-tematicos/ciclovias.png', image: '/images/t-ciclovia.svg', primary_color: '#489969', secondary_color: '#397652')
MainTheme.create(name: 'Cultura y Recreación', icon: '/images/ejes-tematicos/cultura-enttretencion.png', image: '/images/t-cultura.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Educación', icon: '/images/ejes-tematicos/educacion.png', image: '/images/t-educacion.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Emprendedores', icon: '/images/ejes-tematicos/emprendedores.png', image: '/images/t-emprendimiento.svg', primary_color: '#e0d276', secondary_color: '#B0A55E')
MainTheme.create(name: 'Eventos', icon: '/images/ejes-tematicos/eventos.png', image: '/images/t-grandeseventos.svg', primary_color: '#e0d276', secondary_color: '#B0A55E')
MainTheme.create(name: 'Jóvenes', icon: '/images/ejes-tematicos/jovenes.png', image: '/images/t-jovenes.svg', primary_color: '#243D7E', secondary_color: '#37539A')
MainTheme.create(name: 'Mascotas', icon: '/images/ejes-tematicos/mascotas.png', image: '/images/t-mascotas.svg', primary_color: '#243D7E', secondary_color: '#37539A')
MainTheme.create(name: 'Mujeres', icon: '/images/ejes-tematicos/mujeres.png', image: '/images/t-mujeres.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Salud Mental', icon: '/images/ejes-tematicos/salud-mental.png', image: '/images/t-saludmental.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Seguridad', icon: '/images/ejes-tematicos/seguridad.png', image: '/images/t-seguridad.svg', primary_color: '#c44556', secondary_color: '#9C3947')
MainTheme.create(name: 'Smart City', icon: '/images/ejes-tematicos/smartcity.png', image: '/images/t-smartcity.svg', primary_color: '#e0d276', secondary_color: '#B0A55E')
MainTheme.create(name: 'Desarrollo Sostenible', icon: '/images/ejes-tematicos/sustentabilidad.png', image: '/images/t-sustentable.svg', primary_color: '#489969', secondary_color: '#397652')
MainTheme.create(name: 'Mejor Vivienda', icon: '/images/ejes-tematicos/vivienda.png', image: '/images/t-mejorvivienda.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Nuevo Plan Regulador', icon: '/images/ejes-tematicos/planificacionurbana.png', image: '/images/t-npr.svg', primary_color: '#489969', secondary_color: '#397652')
MainTheme.create(name: 'Salud', icon: '/images/ejes-tematicos/salud.png', image: '/images/t-salud.svg', primary_color: '#4569c4', secondary_color: '#37539A')
MainTheme.create(name: 'Plan Verano', icon: '/images/ejes-tematicos/plan-verano.png', image: '/images/t-planverano.png', primary_color: '#fc9d54', secondary_color: '#fc6c04')  # TEMP
MainTheme.create(name: 'Consultas Patentes de Alcoholes', icon: '/images/ejes-tematicos/patente-alcoholes.png', image: '/images/t-patentealcoholes.png', primary_color: '#D79CD8', secondary_color: '#7E0995')  # TEMP
