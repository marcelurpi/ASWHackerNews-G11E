class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy comment like unlike]

  # GET /posts or /posts.json
  def index
    if !params[:ask].nil? && params[:ask]
      @posts = Post.where(url: "")
    elsif !params[:newest].nil? && params[:newest]
      @posts = Post.all.sort { |a, b| -a.created_at.to_i <=> -b.created_at.to_i }
    else
      @posts = Post.all.sort { |a, b| -a.points <=> -b.points }
    end
  end
  
  def ask
    @postsask = Post.where(url: "")
  end 
  
  # GET /posts/1 or /posts/1.json
  def show
    @comments = Comment.all
    @users = User.all
  end

  # GET /posts/new
  def new
    @post = Post.new
    if cookies.signed[:user_id].nil?
      redirect_to(login_path)
    end
  end
  
  # PUT /posts/1/comment
  def comment
    if cookies.signed[:user_id].nil?
      redirect_to(login_path)
    
    else
      @post.numcomments += 1;
      @comment = @post.comments.create(content: params[:content], user_id: params[:user_id], post_id: params[:post_id]) #supuestamente el id del post ya está asociado a comment
      
      redirect_to (@post)
    end
  end

  # GET /posts/1/edit
  def edit
  end

  #Hauria de trobar la manera d'identificar si l'usuari actual ha donat like o no per quan tinguem un login
  #Em dona error de Nil class com si el que li passés de l'índex estigués buit
  def like
    @post.points = @post.points + 1
    @post.save
    respond_to do |format|
      format.html { redirect_to "/posts"}
      format.json { head :no_content }
    end
  end
  
  # Encara no comprovat pq no puc treure el like que no he posat abans
  def unlike
    @post.points = @post.points - 1
    @post.save
    respond_to do |format|
      format.html { redirect_to "/posts"}
      format.json { head :no_content }
    end
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    if !Post.find_by(url: @post.url).nil?
      redirect_to(Post.find_by(url: @post.url))
    else
      
      
      content = nil
      if !@post.url.nil? && !@post.url.empty? && !@post.content.nil? && !@post.content.empty?
        content = @post.content
        @post.content = ""
      end
      respond_to do |format|
        if @post.save
          if !content.nil?
            @post.numcomments += 1;
            author_id = User.find_by(name: @post.author).id
            @comment = @post.comments.create(content: content, user_id: author_id, post_id: @post.id)
          end
          format.html { redirect_to "/posts?newest=true", notice: "Post was successfully created." }
          format.json { head :no_content }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.permit(:created_at, :updated_at,  :title, :content, :author, :url, :id_post)
    end
end