class CommentsController < ApplicationController
  before_action :find_commentable, :set_comment, only: [:show, :update, :destroy, :comment]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end
  
  def threads
    if cookies.signed[:user_id].nil?
      redirect_to(login_path)
    else
      @comments = Comment.where(user_id: cookies.signed[:user_id])
    end
  end

  # PUT /posts/1/comment
  def comment
    if cookies.signed[:user_id].nil?
      redirect_to(login_path)
      
    else
      @child = @commentable.comments.create(content: params[:content], user_id: params[:user_id])
    
      redirect_to (@commentable)
    end
  end
  
  

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    if @comment.commentable_type == 'Comment'
      @comment.post_id = Comment.find(@comment.commentable_id).post_id
    end

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :commentable_id, :commentable_type, :user_id)
    end
    
    def find_commentable
      if params[:comment_id]
        @commentable = Comment.find_by_id(params[:comment_id])
        logger.debug "parent is a comment"
      else params[:post_id]
        @commentable = Post.find_by_id(params[:post_id])
        logger.debug "parent is a post"
      end
    end
end
