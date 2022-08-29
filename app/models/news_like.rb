class NewsLike < ApplicationRecord
    self.table_name = "news_like"
    belongs_to :news
end
