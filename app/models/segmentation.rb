class Segmentation < ApplicationRecord

  has_many :gender_segmentations
  has_many :age_segmentations
  has_many :age_range_segmentations
  has_many :polygon_segmentations
  has_many :radius_segmentations

  has_and_belongs_to_many :sectors
  has_and_belongs_to_many :neighbor_types
  has_and_belongs_to_many :macro_territories

  validates :entity_id, uniqueness: { scope: :entity_name }

  ############################################################
  # CONSTANTS
  ############################################################
  GENDER_MALE = 'Masculino'
  GENDER_FEMALE = 'Femenino'
  GENDER_OTHER = 'Otro'
  GENDER_CHOICES = [
    GENDER_MALE,
    GENDER_FEMALE,
    GENDER_OTHER
  ]

  AGE_RANGES = [
    [0, 18],
    [18, 24],
    [25, 29],
    [30, 39],
    [40, 49],
    [50, 64],
    [65, 79],
    [80, 144],
  ]

  AGE_VALUE = 'AGE'
  AGE_RANGE = 'AGE_RANGE'
  AGE_CHOICES = {
    AGE_VALUE => 'Edades fijas',
    AGE_RANGE => 'Rangos etarios'
  }

  GEO_POLYGON = 'GEO_POLYGON'
  GEO_RADIUS = 'GEO_RADIUS'
  GEO_MACRO_TERRITORY = 'GEO_MACRO_TERRITORY'
  GEO_SECTOR = 'GEO_SECTOR'
  GEO_CHOICES = {
    GEO_POLYGON => 'Polígono',
    GEO_RADIUS => 'Radio',
    GEO_MACRO_TERRITORY => 'Macro territorio',
    GEO_SECTOR => 'Unidad Vecinal'
  }

  ############################################################
  # CREATION HELPERS
  ############################################################

  def self.generate(entity_name:, entity_id:, params:)
    if entity_name.constantize.exists?(id: entity_id)
      if Segmentation.exists?(entity_name: entity_name, entity_id: entity_id)
        segmentation = Segmentation.find_by(entity_name: entity_name, entity_id: entity_id)
      else
        segmentation = Segmentation.create(entity_name: entity_name, entity_id: entity_id)
      end

      segmentation.create_neighbor_types(params)
      segmentation.create_genders(params)
      segmentation.create_ages(params)
      segmentation.create_geos(params)
    end
  end

  ############################################################
  # VALIDATION METHODS
  ############################################################

  def validate_age(user)
    if self.age_type.nil?
      return true
    end

    case self.age_type
    when AGE_VALUE
      if self.age_segmentations.empty? or self.age_segmentations.pluck(:age).include?(user.age)
        return true
      else
        return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
      end
  
    when AGE_RANGE
      in_range = false

      if self.age_range_segmentations.empty?
        in_range = true
      else
        self.age_range_segmentations.each do |age_range|
          if Array(age_range.min_age .. age_range.max_age).include?(user.age)
            in_range = true
          end
        end
      end

      if in_range == true
        return true
      else
        return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
      end

    else
      return true
    end
  end

  def validate_gender(user)
    if self.gender_segmentations.empty? or self.gender_segmentations.pluck(:gender).include?(user.gender)
      return true
    else
      return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
    end
  end

  def validate_neighbor_type(user)
    if self.neighbor_types.empty? or self.neighbor_types.include?(user.neighbor_type)
      return true
    else
      readable_text = self.get_allowed_neighbors_readable_text()
      return "Este proceso está habilitado sólo para <strong>#{readable_text}</strong>."
    end
  end

  def validate_geo(user)
    if self.geo_type.nil?
      return true
    end

    case self.geo_type
    when GEO_SECTOR
      if self.sectors.empty? or self.sectors.include?(user.sector)
        return true
      else
        joined_sectors = self.sectors.map{ |s| s.name }.join(', ')
        return "Este proceso está habilitado sólo para residentes de la(s) unidad(es) vecinal(es):<br> #{joined_sectors}."
      end

    when GEO_MACRO_TERRITORY
      if self.macro_territories.empty?
        return true
      elsif user.sector.nil?
        return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
      else
        if (self.macro_territories.pluck(:id) & user.sector.macro_territories.pluck(:id)).any?
          return true
        else
          return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
        end
      end

    when GEO_RADIUS
      intersects = false

      if user.lat.present? && user.long.present?
        self.radius_segmentations.each do |rs|
          intersects = Segmentation.point_in_polygon(
            rs.coordinates.map{ |x| [x[0].to_d, x[1].to_d] },
            user.lat,
            user.long,
          )
          puts intersects
        end
      end
      puts '2'

      if intersects == true
        return true
      else
        return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
      end

    when GEO_POLYGON
      intersects = false

      if user.lat.present? && user.long.present?
        self.polygon_segmentations.each do |ps|
          intersects = Segmentation.point_in_polygon(
            ps.coordinates.map{ |x| [x[0].to_d, x[1].to_d] },
            user.lat,
            user.long,
          )
        end
      end
      
      if intersects == true
        return true
      else
        return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
      end

    else
      return true
    end
  end

  def validate(user)

    age_validation = validate_age(user)

    if age_validation != true
      return false, age_validation
    end

    gender_validation = validate_gender(user)

    if gender_validation != true
      return false, gender_validation
    end

    geo_validation = validate_geo(user)

    if geo_validation != true
      return false, geo_validation
    end

    neighbor_type_validation = validate_neighbor_type(user)

    if neighbor_type_validation != true
      return false, neighbor_type_validation
    end

    return true, nil
  end

  ############################################################
  # CREATION METHODS
  ############################################################

  def create_neighbor_types(params)
    neighbor_types = params['segmentation_neighbor_types']
    self.neighbor_types.delete_all

    if neighbor_types.present?
      neighbor_types.each do |id|
        neighbor_type = NeighborType.find(id)
        self.neighbor_types.append(neighbor_type)
      end
    end
  end

  def create_genders(params)
    genders = params['segmentation_genders']
    GenderSegmentation.where(segmentation: self).delete_all

    if genders.present?
      genders.each do |gender|
        GenderSegmentation.create(segmentation: self, gender: gender)
      end
    end
  end

  def create_ages(params)
    age_choice = params['age_choice']
    AgeSegmentation.where(segmentation: self).delete_all
    AgeRangeSegmentation.where(segmentation: self).delete_all
    self.age_type = nil
    self.save!

    if AGE_CHOICES.keys.include?(age_choice)
      self.age_type = age_choice
      self.save!

      case age_choice
      when AGE_VALUE
        ages = params['segmentation_ages']

        if ages.present?
          ages.each do |age|
            AgeSegmentation.create(segmentation: self, age: age)
          end
        end

      when AGE_RANGE
        age_ranges = params['segmentation_age_ranges']

        if age_ranges.present?
          age_ranges.each do |age_range|
            min_age, max_age = JSON.parse(age_range)
            AgeRangeSegmentation.create(segmentation: self, min_age: min_age, max_age: max_age)
          end
        end

      else
        nil
      end
    end
  end

  def delete_geos
    self.sectors.delete_all
    self.macro_territories.delete_all
    RadiusSegmentation.where(segmentation: self).delete_all
    PolygonSegmentation.where(segmentation: self).delete_all
    self.geo_type = nil
    self.save!
  end

  def create_geos(params)
    geo_choice = params['geo_choice']
    delete_geos()

    if GEO_CHOICES.keys.include?(geo_choice)
      self.geo_type = geo_choice
      self.save!

      case geo_choice
      when GEO_SECTOR
        sectors = params['segmentation_sectors']

        if sectors.present?
          sectors.each do |id|
            sector = Sector.find_by(id: id)

            if sector.present?
              self.sectors.append(sector)
            end
          end
        end

      when GEO_MACRO_TERRITORY
        macro_territories = params['segmentation_macro_territories']

        if macro_territories.present?
          macro_territories.each do |id|
            macro_territory = MacroTerritory.find_by(id: id)

            if macro_territory.present?
              self.macro_territories.append(macro_territory)
            end
          end
        end

      when GEO_RADIUS
        lat = params['segmentation_geo_radius_lat']
        long = params['segmentation_geo_radius_long']
        meters = params['segmentation_geo_radius_meters']
        raw_coordinates = params['segmentation_geo_radius_coordinates']

        if !raw_coordinates.present?
          return
        end

        coordinates = JSON.parse(raw_coordinates)

        if lat.present? && long.present? and meters.present?
          RadiusSegmentation.create(segmentation: self, lat: lat, long: long, meters: meters, coordinates: coordinates)
        end

      when GEO_POLYGON
        raw_value = params['segmentation_geo_polygon_value']

        if raw_value.present?
          coordinates = JSON.parse(raw_value)

          if !coordinates.empty?
            PolygonSegmentation.create(segmentation: self, coordinates: coordinates)
          end
        end

      else
        nil
      end
    end
  end

  ############################################################
  # UTILS METHODS
  ############################################################

  def self.point_in_polygon(points, lat, long)
    x = lat
    y = long
    inside = false

    points.each_with_index do |p1, i|
      p2 = points[(i + 1) % points.length]
      if ((p1[1] > y) != (p2[1] > y)) && (x < (p2[0] - p1[0]) * (y - p1[1]) / (p2[1] - p1[1]) + p1[0])
        inside = !inside
      end
    end

    inside
  end

  def get_allowed_neighbors_readable_text()
    readable_text = ''

    if Set.new(['Vecino Residente Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      readable_text = 'vecinos residentes'

      if self.sectors.any? && Set.new(self.sectors.map{ |s| s.name }) != Set.new(Sector.all.map{ |s| s.name })
        joined_sectors = self.sectors.map{ |s| s.name }.join(', ')
        readable_text = "residentes de la(s) unidad(es) vecinal(es):<br> #{joined_sectors}"
      end

    elsif Set.new(['Vecino Residente Las Condes', 'Vecino Flotante Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      readable_text = 'vecinos residentes y flotantes'
    elsif Set.new(['Vecino Flotante Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      readable_text = 'vecinos flotantes'
    end

    return readable_text
  end
end
