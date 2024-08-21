class Admin::ActivityController < Admin::BaseController
  has_filters %w[on_users on_proposals on_comments on_surveys]

  def show
    @activity = Activity.for_render.send(@current_filter)
                        .order(created_at: :desc).page(params[:page])
  end
end
