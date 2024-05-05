class CensusRecord < ApplicationRecord
  validates :document_number, presence: true
  validates :document_number, uniqueness: true

  scope :search, ->(terms) { where("document_number ILIKE ?", "%#{terms}%") }

  def human_name
    self.document_number
  end
end
