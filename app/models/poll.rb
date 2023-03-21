class Poll < ApplicationRecord
  require_dependency "poll/answer"

  include Imageable
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases
  include Notifiable
  include Searchable
  include Sluggable
  include StatsVersionable
  include Reportable
  include SDG::Relatable

  translates :name,        touch: true
  translates :summary,     touch: true
  translates :description, touch: true
  include Globalizable

  RECOUNT_DURATION = 1.week

  has_many :booth_assignments, class_name: "Poll::BoothAssignment"
  has_many :booths, through: :booth_assignments
  has_many :partial_results, through: :booth_assignments
  has_many :recounts, through: :booth_assignments
  has_many :voters
  has_many :officer_assignments, through: :booth_assignments
  has_many :officers, through: :officer_assignments
  has_many :questions, inverse_of: :poll, dependent: :destroy
  has_many :comments, as: :commentable, inverse_of: :commentable
  has_many :ballot_sheets

  has_many :geozones_polls
  has_many :geozones, through: :geozones_polls
  belongs_to :author, -> { with_hidden }, class_name: "User", inverse_of: :polls
  belongs_to :related, polymorphic: true
  belongs_to :budget
  belongs_to :main_theme

  has_many :poll_sectors
  has_many :poll_neighbor_types
  has_many :sectors, through: :poll_sectors
  has_many :neighbor_types, through: :poll_neighbor_types

  has_one :poll_result

  validates_translation :name, presence: true
  validate :date_range
  validate :only_one_active, unless: :public?

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  scope :for, ->(element) { where(related: element) }
  scope :current,  -> { where("starts_at <= ? and ? <= ends_at", Date.current.beginning_of_day, Date.current.beginning_of_day) }
  scope :expired,  -> { where("ends_at < ?", Date.current.beginning_of_day) }
  scope :recounting, -> { where(ends_at: (Date.current.beginning_of_day - RECOUNT_DURATION)..Date.current.beginning_of_day) }
  scope :published, -> { where(published: true) }
  scope :by_geozone_id, ->(geozone_id) { where(geozones: { id: geozone_id }.joins(:geozones)) }
  scope :public_for_api, -> { all }
  scope :not_budget, -> { where(budget_id: nil) }
  scope :created_by_admin, -> { where(related_type: nil) }
  scope :with_results, -> { where(id: Report.where(process_type: 'Poll', results: true).pluck(:process_id)) }

  def self.sort_for_list(user = nil)
    all.sort do |poll, another_poll|
      [poll.weight(user), poll.starts_at, poll.name] <=> [another_poll.weight(user), another_poll.starts_at, another_poll.name]
    end
  end

  def self.overlaping_with(poll)
    where("? < ends_at and ? >= starts_at", poll.starts_at.beginning_of_day,
                                            poll.ends_at.end_of_day).where.not(id: poll.id)
                                            .where(related: poll.related)
  end

  def segmentation
    Segmentation.find_by(entity_name: self.class.name, entity_id: self.id)
  end

  def title
    name
  end

  def current?(timestamp = Date.current.beginning_of_day)
    starts_at <= timestamp && timestamp <= ends_at
  end

  def expired?(timestamp = Date.current.beginning_of_day)
    ends_at < timestamp
  end

  def has_results?
    return Report.where(process_type: 'Poll', process_id: id, results: true).exists?
  end

  def recounts_confirmed?
    ends_at < 1.month.ago
  end

  def self.current_or_recounting
    current.or(recounting)
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
      inner_message = self.sectors.map{ |s| s.name }.join(', ')
      return "Este proceso está habilitado solo para <br>residentes de la(s) unidad(es) vecinal(es):<br><strong>#{inner_message}.</strong>"
    else
      return "Este proceso está habilitado solo para<br><strong>#{user_types}</strong>"
    end

    return ''
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

  def answerable_by?(user)
    user.present? && current?
  end

  def self.answerable_by(user)
    return none if user.nil? || user.unverified?

    current.left_joins(:geozones)
      .where("geozone_restricted = ? OR geozones.id = ?", false, user.geozone_id)
  end

  def self.votable_by(user)
    answerable_by(user).not_voted_by(user)
  end

  def votable_by?(user)
    return false if user_has_an_online_ballot?(user)

    answerable_by?(user) && not_voted_by?(user)
  end

  def user_has_an_online_ballot?(user)
    budget.present? && budget.ballots.find_by(user: user)&.lines.present?
  end

  def self.not_voted_by(user)
    where.not(id: poll_ids_voted_by(user))
  end

  def self.poll_ids_voted_by(user)
    return -1 if Poll::Voter.where(user: user).empty?

    Poll::Voter.where(user: user).pluck(:poll_id)
  end

  def not_voted_by?(user)
    Poll::Voter.where(poll: self, user: user).empty?
  end

  def full_answered_by?(user)
    questions.map{ |q| q.answers.pluck(:author_id).include?(user.id) }.all?
  end

  def voted_by?(user)
    Poll::Voter.where(poll: self, user: user).exists?
  end

  def voted_in_booth?(user)
    Poll::Voter.where(poll: self, user: user, origin: "booth").exists?
  end

  def voted_in_web?(user)
    Poll::Voter.where(poll: self, user: user, origin: "web").exists?
  end

  def date_range
    unless starts_at.present? && ends_at.present? && starts_at <= ends_at
      errors.add(:starts_at, I18n.t("errors.messages.invalid_date_range"))
    end
  end

  def generate_slug?
    slug.nil?
  end

  def only_one_active
    return unless starts_at.present?
    return unless ends_at.present?
    return unless Poll.overlaping_with(self).any?

    errors.add(:starts_at, I18n.t("activerecord.errors.messages.another_poll_active"))
  end

  def public?
    related.nil?
  end

  def answer_count
    Poll::Answer.where(question: questions).count
  end

  def budget_poll?
    budget.present?
  end

  def searchable_translations_definitions
    {
      name        => "A",
      summary     => "C",
      description => "D"
    }
  end

  def searchable_values
    searchable_globalized_values
  end

  def self.search(terms)
    pg_search(terms)
  end

  def weight(user)
    if geozone_restricted?
      if answerable_by?(user)
        50
      else
        100
      end
    else
      0
    end
  end
end
