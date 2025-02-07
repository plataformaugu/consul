class Survey::Item < ApplicationRecord
  belongs_to :survey

  has_many :answers, class_name: 'Survey::Item::Answer', foreign_key: 'survey_item_id', dependent: :destroy
  has_many :dependant_items, class_name: 'Survey::Item', foreign_key: 'item_dependency_id', dependent: :destroy

  ITEM_TYPE_TEXT = 'item_type_text'
  ITEM_TYPE_UNIQUE = 'item_type_unique'
  ITEM_TYPE_MULTIPLE = 'item_type_multiple'
  ITEM_TYPE_RANKING = 'item_type_ranking'

  ITEM_TYPES = [
    ITEM_TYPE_TEXT,
    ITEM_TYPE_UNIQUE,
    ITEM_TYPE_MULTIPLE,
    ITEM_TYPE_RANKING,
  ]

  ITEM_TYPE_TRANSLATIONS = {
    ITEM_TYPE_TEXT => 'Pregunta abierta',
    ITEM_TYPE_UNIQUE => 'Selección única',
    ITEM_TYPE_MULTIPLE => 'Selección múltiple',
    ITEM_TYPE_RANKING => 'Ranking'
  }

  def component
    case self.item_type
    when ITEM_TYPE_UNIQUE
      Surveys::UniqueComponent.new(self)
    when ITEM_TYPE_MULTIPLE
      Surveys::MultipleComponent.new(self)
    when ITEM_TYPE_RANKING
      Surveys::RankingComponent.new(self)
    when ITEM_TYPE_TEXT
      Surveys::TextComponent.new(self)
    end
  end

  private
  
  def validate_item_dependency
    if item_dependency_id.present?
      dependency_item = Survey::Item.find_by(id: item_dependency_id)

      unless dependency_item
        errors.add(:item_dependency_id, 'la dependencia no existe')
      else
        if item_dependency_answer.present?
          unless dependency_item.data.include?(item_dependency_answer)
            errors.add(:item_dependency_answer, 'la respuesta de la dependencia no existe')
          end
        else
          errors.add(:item_dependency_answer, 'debe tener un valor válido')
        end
      end
    end
  end
end
