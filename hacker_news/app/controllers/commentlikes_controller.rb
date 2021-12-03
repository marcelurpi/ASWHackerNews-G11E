class CommentlikesController < ApplicationController
    before_action :find_comment
    before_action :find_commentlike, only: [:destroy]
    
  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to) }
        format.json { head :unauthorized }
      end
    else
      @newlike = @comment.commentlikes.create(user_id: cookies.signed[:user_id])
      @comment.points+=1
      @comment.save
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to) }
        format.json { render json: @newlike}
      end
    end
  end
    
  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot unlike"
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to) }
        format.json { head :unauthorized }
      end
    else
      @commentlike.comment.points-=1
      @commentlike.comment.save
      @commentlike.destroy
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to) }
        format.json { render json: @commentlike.comment}
      end
    end
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
