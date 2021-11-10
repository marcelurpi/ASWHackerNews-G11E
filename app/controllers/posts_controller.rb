class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.sort { |a, b| -a.points <=> -b.points }
  end
  
  def newest
    @posts = Post.all.sort { |a, b| -a.created_at.to_i <=> -b.created_at.to_i }
  end
  
  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end
  
  # PUT /posts/1/comment
  def comment
      @comment = @post.comments.create(content: params[:content], id_post: @post.id_post)
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
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to "/posts/newest", notice: "Post was successfully created." }
        format.json { head :no_content }
=begin
      if @post.title != "" and @post.save         #contrubions tipus url o normal (titol amb url OR content)
        if (@post.url == "" and @post.content != "") or (@post.content == "" and @post.url != "")
          format.html { redirect_to "/posts/newest", notice: "Post was successfully created." }
          format.json { head :no_content }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @post.errors, status: :unprocessable_entity }

      elsif @post.title == "" and @post.save and @post.url == "" and @post.content == ""          #tipus ask
        #falta implementar :
        # Publicació de noves Contribucions de tipus "ask". Fixeu-vos que si s'omplen alhora els camps "url" i "text", 
        #si l"url" és correcte i no existeix, es crea una nova Contribució per a aquell "url" i un nou comentari 
        #associat a aquesta Contribució amb el contingut del camp "text". L'autor del comentari és, òbviament, el mateix que 
        #ha creat la Contribució
=end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
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