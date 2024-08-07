class News < ApplicationRecord
  scope :published, -> { where.not(published_at: nil) }

  has_one_attached :image, :dependent => :destroy
end
