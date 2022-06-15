class UserSegments
  def self.segments
    %w[
        all_users
        administrators
        c1
        c2
        c3
        c4
        c5
        c6
        c7
        c8
        c9
        c10
        c11
        c12
        c13
        c14
        c15
        c16
        c17
        c18
        c19
        c20
        c21
        c22
        c23
        c24
        c25
      ]
  end

  def self.segment_name(segment)
    geozones[segment.to_s]&.name || I18n.t("admin.segment_recipient.#{segment}") if valid_segment?(segment)
  end

  # Sectors
  def self.c1
    User.where(sector_id: Sector.find_by(name: 'C1').id)
  end

  def self.c2
    User.where(sector_id: Sector.find_by(name: 'C2').id)
  end

  def self.c3
    User.where(sector_id: Sector.find_by(name: 'C3').id)
  end

  def self.c4
    User.where(sector_id: Sector.find_by(name: 'C4').id)
  end

  def self.c5
    User.where(sector_id: Sector.find_by(name: 'C5').id)
  end

  def self.c6
    User.where(sector_id: Sector.find_by(name: 'C6').id)
  end

  def self.c7
    User.where(sector_id: Sector.find_by(name: 'C7').id)
  end
  
  def self.c8
    User.where(sector_id: Sector.find_by(name: 'C8').id)
  end
  
  def self.c9
    User.where(sector_id: Sector.find_by(name: 'C9').id)
  end

  def self.c10
    User.where(sector_id: Sector.find_by(name: 'C10').id)
  end

  def self.c11
    User.where(sector_id: Sector.find_by(name: 'C11').id)
  end

  def self.c12
    User.where(sector_id: Sector.find_by(name: 'C12').id)
  end

  def self.c13
    User.where(sector_id: Sector.find_by(name: 'C13').id)
  end

  def self.c14
    User.where(sector_id: Sector.find_by(name: 'C14').id)
  end

  def self.c15
    User.where(sector_id: Sector.find_by(name: 'C15').id)
  end

  def self.c16
    User.where(sector_id: Sector.find_by(name: 'C16').id)
  end

  def self.c17
    User.where(sector_id: Sector.find_by(name: 'C17').id)
  end
  
  def self.c18
    User.where(sector_id: Sector.find_by(name: 'C18').id)
  end
  
  def self.c19
    User.where(sector_id: Sector.find_by(name: 'C19').id)
  end

  def self.c20
    User.where(sector_id: Sector.find_by(name: 'C20').id)
  end

  def self.c21
    User.where(sector_id: Sector.find_by(name: 'C21').id)
  end

  def self.c22
    User.where(sector_id: Sector.find_by(name: 'C22').id)
  end

  def self.c23
    User.where(sector_id: Sector.find_by(name: 'C23').id)
  end

  def self.c24
    User.where(sector_id: Sector.find_by(name: 'C24').id)
  end

  def self.c25
    User.where(sector_id: Sector.find_by(name: 'C25').id)
  end

  def self.all_users
    User.active.where.not(confirmed_at: nil)
  end

  def self.administrators
    all_users.administrators
  end

  def self.all_proposal_authors
    author_ids(Proposal.pluck(:author_id))
  end

  def self.proposal_authors
    author_ids(Proposal.not_archived.not_retired.pluck(:author_id))
  end

  def self.investment_authors
    author_ids(current_budget_investments.pluck(:author_id))
  end

  def self.feasible_and_undecided_investment_authors
    unfeasible_and_finished_condition = "feasibility = 'unfeasible' and valuation_finished = true"
    investments = current_budget_investments.where.not(unfeasible_and_finished_condition)
    author_ids(investments.pluck(:author_id))
  end

  def self.selected_investment_authors
    author_ids(current_budget_investments.selected.pluck(:author_id))
  end

  def self.winner_investment_authors
    author_ids(current_budget_investments.winners.pluck(:author_id))
  end

  def self.not_supported_on_current_budget
    author_ids(
      User.where.not(
        id: Vote.select(:voter_id).where(votable: current_budget_investments).distinct
      )
    )
  end

  def self.valid_segment?(segment)
    segments.include?(segment.to_s)
  end

  def self.recipients(segment)
    if geozones[segment.to_s]
      all_users.where(geozone: geozones[segment.to_s])
    else
      send(segment)
    end
  end

  def self.user_segment_emails(segment)
    recipients(segment).newsletter.order(:created_at).pluck(:email).compact
  end

  private

    def self.current_budget_investments
      Budget.current.investments
    end

    def self.author_ids(author_ids)
      all_users.where(id: author_ids)
    end

    def self.geozones
      Geozone.order(:name).map do |geozone|
        [geozone.name.gsub(/./) { |char| character_approximation(char) }.underscore.tr(" ", "_"), geozone]
      end.to_h
    end

    def self.character_approximation(char)
      I18n::Backend::Transliterator::HashTransliterator::DEFAULT_APPROXIMATIONS[char] || char
    end
end
