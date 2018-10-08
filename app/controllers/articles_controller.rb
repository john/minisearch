class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @tags = ActsAsTaggableOn::Tag.all
    if params[:q]
      q = params[:q]
      @articles = Article.where("name LIKE ? OR description LIKE ? OR url LIKE ?", "%#{q}%", "%#{q}%", "%#{q}%")
      
      # tagged articles too
      @articles += Article.tagged_with(q)
      
    elsif params[:tag]
      @articles = Article.tagged_with( params[:tag] )
      @active_tags = params[:tag].split(',')
      logger.debug "active tags: #{@active_tags.inspect}"
    else
      @articles = Article.all
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    flattened_tag_list = params[:article][:tag_list]&.map { |s| "#{s}" if s.present? }&.join(',')
    logger.debug "flattened_tag_list: #{flattened_tag_list}"
    @article.tag_list = flattened_tag_list
    logger.debug "@article.tag_list2: " + @article.tag_list.inspect
    
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:created_by, :name, :url, :description, :tag_list)
    end
end
