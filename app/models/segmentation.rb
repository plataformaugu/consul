class Segmentation < ApplicationRecord
  has_many :gender_segmentations
  has_many :age_segmentations
  has_many :age_range_segmentations

  has_and_belongs_to_many :sectors

  validates :entity_id, uniqueness: { scope: :entity_name }

  ############################################################
  # CONSTANTS
  ############################################################
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

  GEO_SECTOR = 'GEO_SECTOR'
  GEO_CHOICES = {
    GEO_SECTOR => 'Sector'
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

      segmentation.in_census = params.fetch('segmentation_in_census', "0") == "1"
      segmentation.save!

      segmentation.create_genders(params)
      segmentation.create_ages(params)
      segmentation.create_geos(params)
    end
  end

  ############################################################
  # VALIDATION METHODS
  ############################################################
  def validate_census(user)
    if !self.in_census
      return true
    end

    if CensusRecord.exists?(document_number: user.document_number)
      return true
    else
      return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
    end
  end

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
    if self.gender_segmentations.empty?
      return true
    elsif self.gender_segmentations.pluck(:gender).include?(user.gender)
      return true
    elsif ![User::GENDER_MALE, User::GENDER_FEMALE].include?(user.gender) and self.gender_segmentations.pluck(:gender).include?(User::GENDER_OTHER)
      return true
    else
      return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
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

    else
      return true
    end
  end

  def validate(user)
    census_validation = validate_census(user)

    if census_validation != true
      return false, census_validation
    end

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

    return true, nil
  end

  ############################################################
  # CREATION METHODS
  ############################################################
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
            sector = Sector.find_by(internal_id: id)

            if sector.present?
              self.sectors.append(sector)
            end
          end
        end
      else
        nil
      end
    end
  end
end
