class Admin::Poll::PollsController < Admin::Poll::BaseController
  include Translatable
  include ImageAttributes
  include ReportAttributes
  load_and_authorize_resource

  before_action :load_search, only: [:search_booths, :search_officers]
  before_action :load_geozones, only: [:new, :create, :edit, :update]

  def index
    @polls = Poll.not_budget.created_by_admin.order(starts_at: :desc)
  end

  def show
    @poll = Poll.find(params[:id])
  end

  def new
  end

  def create
    @poll = Poll.new(poll_params.merge(author: current_user))

    if @poll.save
      Segmentation.generate(entity_name: @poll.class.name, entity_id: @poll.id, params: params)
      notice = t("flash.actions.create.poll")
      if @poll.budget.present?
        redirect_to admin_poll_booth_assignments_path(@poll), notice: notice
      else
        redirect_to [:admin, @poll], notice: notice
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if poll_params.has_key?('show_demographics')
      if poll_params['show_demographics'] == '1'
        age_groups = {
          '16 a 24' => [16, 24],
          '25 a 34' => [25, 34],
          '35 a 44' => [35, 44],
          '45 a 54' => [45, 54],
          '55 a 64' => [55, 64],
          '65 a 74' => [65, 74],
          '75 a 84' => [75, 84],
          '85 a 94' => [85, 94],
          '95 a 104' => [95, 104],
          '105 a 114' => [105, 114],
          '115 a 124' => [115, 124],
          '125 a 134' => [125, 134],
          '135 a 144' => [135, 144],
        }
        age_groups_votes_tally =  age_groups.map{ |k, v| [k, User.where(id: @poll.voters.pluck(:user_id)).where('extract(year from date_of_birth) BETWEEN ? AND ?', Time.now.year - v[1], Time.now.year - v[0]).count] }.filter{|k, v| v != 0}.to_h.tally

        votes_by_sector_tally = @poll.voters.filter{|p| p.user and p.user.sector.present?}.map{|p| p.user.sector.name}.sort_by{|p| p}.tally
        votes_by_sector = {
          'keys': votes_by_sector_tally.keys,
          'values': votes_by_sector_tally.values
        }

        allowed_genders = ['Masculino', 'Femenino', 'masculino', 'femenino']
        votes_by_gender_tally = @poll.voters.filter{|p| p.user}.map{|p| allowed_genders.include?(p.user.gender) ? p.user.gender.titleize : 'Otro'}.tally
        votes_by_gender = {
          'keys': votes_by_gender_tally.keys,
          'values': votes_by_gender_tally.values
        }

        votes_by_age_group = {
          'keys': age_groups_votes_tally.keys,
          'values': age_groups_votes_tally.values
        }

        if !@poll.poll_result.present?
          PollResult.create(
            votes_by_sector: votes_by_sector,
            votes_by_gender: votes_by_gender,
            votes_by_age_group: votes_by_age_group,
            poll_id: @poll.id
          )
        else
          @poll.poll_result.update(
            votes_by_sector: votes_by_sector,
            votes_by_gender: votes_by_gender,
            votes_by_age_group: votes_by_age_group
          )
        end
      end
    end

    if @poll.update(poll_params)
      Segmentation.generate(entity_name: @poll.class.name, entity_id: @poll.id, params: params)
      redirect_to [:admin, @poll], notice: t("flash.actions.update.poll")
    else
      render :edit
    end
  end

  def add_question
    question = ::Poll::Question.find(params[:question_id])

    if question.present?
      @poll.questions << question
      notice = t("admin.polls.flash.question_added")
    else
      notice = t("admin.polls.flash.error_on_question_added")
    end
    redirect_to admin_poll_path(@poll), notice: notice
  end

  def booth_assignments
    @polls = Poll.current.created_by_admin
  end

  def destroy
    if ::Poll::Voter.where(poll: @poll).any?
      redirect_to admin_poll_path(@poll), alert: t("admin.polls.destroy.unable_notice")
    else
      @poll.destroy!

      redirect_to admin_polls_path, notice: t("admin.polls.destroy.success_notice")
    end
  end

  private

    def load_geozones
      @geozones = Geozone.all.order(:name)
    end

    def poll_params
      attributes = [:name, :starts_at, :ends_at, :geozone_restricted, :budget_id, :related_sdg_list, :main_theme_id, :pdf_link, :show_demographics,
                    image_attributes: image_attributes]

      params.require(:poll).permit(*attributes, *report_attributes, translation_params(Poll))
    end

    def search_params
      params.permit(:poll_id, :search)
    end

    def load_search
      @search = search_params[:search]
    end

    def resource
      @poll ||= Poll.find(params[:id])
    end
end
