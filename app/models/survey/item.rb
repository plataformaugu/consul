class Survey::Item < ApplicationRecord
  belongs_to :survey

  has_many :answers, class_name: 'Survey::Item::Answer', foreign_key: 'survey_item_id', dependent: :destroy

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
end
