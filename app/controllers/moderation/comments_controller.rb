class Moderation::CommentsController < Moderation::BaseController
  include ModerateActions

  has_filters %w[pending_flag_review all with_ignored_flag], only: :index
  has_orders %w[flags newest], only: :index

  before_action :load_resources, only: [:index, :moderate]

  load_and_authorize_resource

  def index
    @comments = Kaminari.paginate_array(Comment.where(ignored_flag_at: nil)).page(params[:page])
  end

  def validate
    @comment = Comment.find(params[:id])
    @comment.ignored_flag_at = Time.now
    @comment.save!
    
    redirect_to moderation_comments_path, notice: "El comentario fue marcado como válido."
  end

  def custom_hide
    @comment = Comment.find(params[:id])
    @comment.hide
    Activity.log(current_user, :hide, @comment)

    redirect_to moderation_comments_path, notice: "El comentario fue ocultado."
  end

  private

    def resource_model
      Comment
    end

    def author_id
      :user_id
    end
end
