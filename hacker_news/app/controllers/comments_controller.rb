class CommentsController < ApplicationController
  before_action :find_commentable, :set_comment, only: [:show, :update, :destroy, :comment]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
    if !params[:threads].nil? && params[:threads]
      if cookies.signed[:user_id].nil?
        redirect_to(login_path)
      else
        @comments = Comment.where(user_id: cookies.signed[:user_id])
      end
    elsif !params[:author].nil?
      user = User.find_by(name: params[:author])
      if user.nil?
        respond_to do |format|
          format.html
          format.json { head :bad_request }
        end
        return
      end
      @comments = Comment.where(user_id: user.id)
    elsif !params[:upvoted_by].nil?
      if request.format.json?
        if params['X-API-KEY'].nil?
          respond_to do |format|
            format.html
            format.json { head :unauthorized }
          end
          return
        else
          userC = User.find_by(name: params[:upvoted_by])
          
          key   = ActiveSupport::KeyGenerator.new(ENV['SECRET_KEY']).generate_key(ENV['ENCRYPTION_SALT'], ActiveSupport::MessageEncryptor.key_len)
          crypt = ActiveSupport::MessageEncryptor.new(key)
          author_id = crypt.decrypt_and_verify(params['X-API-KEY'])
          userL = User.find_by(user_id: author_id)
          
          if userC.nil?
            respond_to do |format|
              format.html
              format.json { head :bad_request }
            end
            return
          end
          if userC != userL
            respond_to do |format|
              format.html
              format.json { head :unauthorized }
            end
            return
          end
          likedCommentIds = Commentlike.where(user_id: user.id).select(:comment_id).to_a.map{|c| c.comment_id}
          @comments = Comment.where(id: likedCommentIds)
        end
      end
      likedCommentIds = Commentlike.where(user_id: user.id).select(:comment_id).to_a.map{|c| c.comment_id}
      @comments = Comment.where(id: likedCommentIds)
    elsif !params[:id_post].nil?
      @poste = Post.where(id_post: params[:id_post])
      if @poste.nil?
        p 'es nul'
        respond_to do |format|
          format.html
          format.json { head :bad_request }
        end
        return
      else
        @comments = Comment.where(post_id: params[:id_post])
        p 'no es null'
        respond_to do |format|
          format.html
          format.json { render json: @comments}
        end
      end
    end
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
  end

  # PUT /posts/1/comment
  def comment
    if cookies.signed[:user_id].nil?
      redirect_to(login_path)
      
    else
      key   = ActiveSupport::KeyGenerator.new(ENV['SECRET_KEY']).generate_key(ENV['ENCRYPTION_SALT'], ActiveSupport::MessageEncryptor.key_len)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      author_id = crypt.decrypt_and_verify(params['X-API-KEY'])
      if author_id.nil?
        respond_to do |format|
          format.html
          format.json { head :unauthorized }
        end
        return
      end
      
      @child = @commentable.comments.create(content: params[:content], user_id: params[:user_id])
    
      redirect_to (@commentable)
    end
  end
  
  

  # POST /comments
  # POST /comments.json
  def create
    author_id = nil
    if request.format.json?
      if params['X-API-KEY'].nil?
        respond_to do |format|
          format.html
          format.json { head :unauthorized }
        end
        return
      else
        key   = ActiveSupport::KeyGenerator.new(ENV['SECRET_KEY']).generate_key(ENV['ENCRYPTION_SALT'], ActiveSupport::MessageEncryptor.key_len)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        author_id = crypt.decrypt_and_verify(params['X-API-KEY'])
        if author_id.nil?
          respond_to do |format|
            format.html
            format.json { head :unauthorized }
          end
          return
        end
        if !params[:comment][:content].nil? && !params[:comment][:content].blank?
          @comment = Comment.new(comment_params)
          @comment.commentable_type = 'Post'
          @comment.post_id = params[:post_id],
          @comment.commentable_id = params[:post_id]
          @comment.user_id = author_id
          respond_to do |format|
            if @comment.save
              format.html
              format.json { render json: @comment }
            else
              format.html
              format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
          end
        else
          redirect_to Comment.find(params[:comment_id])
        end
      end
    else
      if !params[:comment][:content].nil? && !params[:comment][:content].blank?
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
      else
        redirect_to Comment.find(params[:comment_id])
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
