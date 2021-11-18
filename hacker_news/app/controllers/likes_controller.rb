class LikesController < ApplicationController
    before_action :find_post
    before_action :find_like, only: [:destroy]

  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @post.likes.create(user_id: cookies.signed[:user_id])
    end
    redirect_to session.delete(:return_to)
  end
  
  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot unlike"
    else
      @like.destroy
    end
    redirect_to session.delete(:return_to)
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
