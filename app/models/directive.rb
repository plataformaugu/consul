class Directive < ApplicationRecord
  has_one_attached :image, :dependent => :destroy
  belongs_to :neighborhood_council
end
