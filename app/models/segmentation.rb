class Segmentation < ApplicationRecord

    has_many :gender_segmentations
    has_many :age_segmentations
    has_many :age_range_segmentations
  
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
  
        segmentation.create_genders(params)
        segmentation.create_ages(params)
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
      if self.gender_segmentations.empty?
        return true
      elsif self.gender_segmentations.pluck(:gender).include?(user.gender)
        return true
      elsif ![GENDER_MALE, GENDER_FEMALE].include?(user.gender) and self.gender_segmentations.pluck(:gender).include?(GENDER_OTHER)
        return true
      else
        return "Este proceso está habilitado sólo para el segmento indicado en las bases del proceso."
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
  
end
