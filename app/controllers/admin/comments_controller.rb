class Admin::CommentsController < Admin::BaseController
  def index
    @comments = Comment.sort_by_newest.page(params[:page])
  end

  def download
    @comments = Comment.sort_by_newest
    @host = request.host

    respond_to do |format|
      format.xlsx { render xlsx: "comments", filename: "comments-#{Date.current}.xlsx" }
    end
  end
end
