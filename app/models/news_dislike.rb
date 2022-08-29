class NewsDislike < ApplicationRecord
    self.table_name = "news_dislike"
    belongs_to :news
end
