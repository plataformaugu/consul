require "numeric"

class Debate < ApplicationRecord
  include Flaggable
  include Taggable
  include Conflictable
  include Measurable
  include Sanitizable
  include Searchable
  include Filterable
  include HasPublicAuthor
  include Graphqlable
  include Relationable
  include Notifiable
  include Randomizable
  include SDG::Relatable

  acts_as_votable
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  translates :title, touch: true
  translates :description, touch: true
  include Globalizable

  belongs_to :author, -> { with_hidden }, class_name: "User", inverse_of: :debates
  belongs_to :geozone
  belongs_to :main_theme

  has_many :comments, as: :commentable, inverse_of: :commentable
  has_many :debate_sectors
  has_many :debate_neighbor_types
  has_many :sectors, through: :debate_sectors
  has_many :neighbor_types, through: :debate_neighbor_types

  validates_translation :title, presence: true, length: { in: 4..Debate.title_max_length }
  validates_translation :description, presence: true
  validate :description_length
  validates :author, presence: true

  before_save :calculate_hot_score, :calculate_confidence_score
  has_one_attached :image, :dependent => :destroy

  scope :for_render,               -> { includes(:tags) }
  scope :sort_by_hot_score,        -> { reorder(hot_score: :desc) }
  scope :sort_by_confidence_score, -> { reorder(confidence_score: :desc) }
  scope :sort_by_created_at,       -> { reorder(created_at: :desc) }
  scope :sort_by_most_commented,   -> { reorder(comments_count: :desc) }
  scope :sort_by_relevance,        -> { all }
  scope :sort_by_flags,            -> { order(flags_count: :desc, updated_at: :desc) }
  scope :sort_by_recommendations,  -> { order(cached_votes_total: :desc) }
  scope :last_week,                -> { where("created_at >= ?", 7.days.ago) }
  scope :featured,                 -> { where.not(featured_at: nil) }
  scope :public_for_api,           -> { all }

  visitable class_name: "Visit"

  attr_accessor :link_required

  def self.recommendations(user)
    tagged_with(user.interests, any: true).where.not(author_id: user.id)
  end

  def self.unpublished
    Debate.where(published_at: nil)
  end

  def self.published
    Debate.where.not(published_at: nil)
  end

  def searchable_translations_definitions
    { title       => "A",
      description => "D" }
  end

  def searchable_values
    {
      author.username    => "B",
      tag_list.join(" ") => "B",
      geozone&.name      => "B"
    }.merge!(searchable_globalized_values)
  end

  def self.search(terms)
    pg_search(terms)
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

  def likes
    cached_votes_up
  end

  def dislikes
    cached_votes_down
  end

  def total_votes
    cached_votes_total
  end

  def votes_score
    cached_votes_score
  end

  def total_anonymous_votes
    cached_anonymous_votes_total
  end

  def editable?
    total_votes <= Setting["max_votes_for_debate_edit"].to_i
  end

  def editable_by?(user)
    editable? && author == user
  end

  def register_vote(user, vote_value)
    if votable_by?(user)
      Debate.increment_counter(:cached_anonymous_votes_total, id) if user.unverified? && !user.voted_for?(self)
      vote_by(voter: user, vote: vote_value)
    end
  end

  def votable_by?(user)
    return false unless user

    total_votes <= 100 ||
      !user.unverified? ||
      Setting["max_ratio_anon_votes_on_debates"].to_i == 100 ||
      anonymous_votes_ratio < Setting["max_ratio_anon_votes_on_debates"].to_i ||
      user.voted_for?(self)
  end

  def anonymous_votes_ratio
    return 0 if cached_votes_total == 0

    (cached_anonymous_votes_total.to_f / cached_votes_total) * 100
  end

  def after_commented
    save # update cache when it has a new comment
  end

  def calculate_hot_score
    self.hot_score = ScoreCalculator.hot_score(self)
  end

  def calculate_confidence_score
    self.confidence_score = ScoreCalculator.confidence_score(cached_votes_total,
                                                             cached_votes_up)
  end

  def after_hide
    tags.each { |t| t.decrement_custom_counter_for("Debate") }
  end

  def after_restore
    tags.each { |t| t.increment_custom_counter_for("Debate") }
  end

  def featured?
    featured_at.present?
  end

  def self.debates_orders(user)
    orders = %w[hot_score confidence_score created_at relevance]
    orders << "recommendations" if Setting["feature.user.recommendations_on_debates"] && user&.recommended_debates
    orders
  end

  def description_length
    real_description_length = ActionView::Base.full_sanitizer.sanitize(description.to_s).squish.length

    if real_description_length < Debate.description_min_length
      errors.add(:description, :too_short, count: Debate.description_min_length)
      translation.errors.add(:description, :too_short, count: Debate.description_min_length)
    end

    if real_description_length > Debate.description_max_length
      errors.add(:description, :too_long, count: Debate.description_max_length)
      translation.errors.add(:description, :too_long, count: Debate.description_max_length)
    end
  end

  def everyone_can_vote?
    if Set.new(['Vecino Residente Las Condes', 'Vecino Flotante Las Condes', 'Registrado sin Tarjeta Vecino']) == Set.new(self.neighbor_types.pluck(:name))
      return true
    elsif Set.new(['Registrado sin Tarjeta Vecino']) == Set.new(self.neighbor_types.pluck(:name))
      return true
    else
      return false
    end
  end

  def can_user_vote?(user)
    if not user
      return false
    end

    if self.sectors.any?
      if not self.sectors.include?(user.sector) or not user.neighbor_type or user.neighbor_type.name != 'Vecino Residente Las Condes'
        return false
      else
        return true
      end
    else
      return self.neighbor_types.include?(user.neighbor_type)
    end
  end

  def get_restriction_message
    user_types = 'todos'

    if self.sectors.any? or Set.new(['Vecino Residente Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      user_types = 'vecinos residentes'
    elsif Set.new(['Vecino Residente Las Condes', 'Vecino Flotante Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      user_types = 'vecinos residentes y flotantes'
    elsif Set.new(['Vecino Flotante Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      user_types = 'vecinos flotantes'
    end

    if self.sectors.any?
      if Set.new(self.sectors.map{ |s| s.name }) == Set.new(Sector.all.map{ |s| s.name })
        return "Este proceso está habilitado solo para<br><strong>vecinos residentes</strong>"
      else
        inner_message = self.sectors.map{ |s| s.name }.join(', ')
      end

      return "Este proceso está habilitado solo para <br>residentes de la(s) unidad(es) vecinal(es):<br><strong>#{inner_message}.</strong>"
    else
      return "Este proceso está habilitado solo para<br><strong>#{user_types}</strong>"
    end

    return ''
  end
end
