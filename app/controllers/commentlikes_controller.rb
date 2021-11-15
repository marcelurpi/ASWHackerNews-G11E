class CommentlikesController < ApplicationController
    before_action :find_comment
    before_action :find_commentlike, only: [:destroy]
    
  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @comment.commentlikes.create(user_id: cookies.signed[:user_id])
    end
    redirect_to session.delete(:return_to)
  end
    
  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot unlike"
    else
      @commentlike.destroy
    end
    redirect_to session.delete(:return_to)
  end
  
  def find_commentlike
    @commentlike = @comment.commentlikes.find(params[:id])
  end
    
  private
  
  def already_liked?
    Commentlike.where(user_id: cookies.signed[:user_id], comment_id: params[:comment_id]).exists?
  end
  
  def find_comment
    session[:return_to] ||= request.referer
    @comment = Comment.find(params[:comment_id])
  end
end
