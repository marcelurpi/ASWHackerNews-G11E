class LikesController < ApplicationController
    before_action :find_post
    before_action :find_like, only: [:destroy]

  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to) }
        format.json { head :unauthorized }
      end
    else
      @newlike = @post.likes.create(user_id: cookies.signed[:user_id])
      @post.points+=1
      @post.save
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
      @like.post.points-=1
      @like.post.save
      @like.destroy
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to) }
        format.json { render json: @like.post}
      end
    end
  end
  
  def find_like
   @like = @post.likes.find(params[:id])
  end

  private
  
  def already_liked?
    Like.where(user_id: cookies.signed[:user_id], post_id: params[:post_id]).exists?
  end

  def find_post
    session[:return_to] ||= request.referer
    @post = Post.find(params[:post_id])
  end

end
