# From: https://mkdev.me/en/posts/how-to-use-query-objects-to-refactor-rails-sql-queries
class FindArticles
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end 
  
  def call(params)
    scoped = search(initial_scope, params[:q])
    scoped = filter_by_tags(scoped, params[:tag])
    scoped = filter_by_article_type(scoped, params[:article_type])
    scoped
  end

  private def search(scoped, q = nil)
    if q
      scoped = scoped.find_by_sql("SELECT DISTINCT \"articles\".* FROM \"articles\" INNER JOIN \"taggings\" \"article_taggings_9124a5b\" ON \"article_taggings_9124a5b\".\"taggable_id\" = \"articles\".\"id\" AND \"article_taggings_9124a5b\".\"taggable_type\" = 'Article' AND \"article_taggings_9124a5b\".\"tag_id\" IN (SELECT \"tags\".\"id\" FROM \"tags\" WHERE LOWER(\"tags\".\"name\") ILIKE '#{q}' ESCAPE '!') OR (name LIKE '%#{q}%' OR description LIKE '%fintech%' OR url LIKE '%#{q}%')")
    else
      scoped
    end
  end
  
  private def filter_by_tags(scoped, tags = nil)
     if tags.present?
       scoped.tagged_with( tags )
     else
       scoped
     end
   end
   
   private def filter_by_article_type(scoped, article_type = nil)
      if article_type && article_type.present?
        scoped.where( 'article_type = ?', Article.article_types[article_type.to_sym])
      else
        scoped
      end
    end
end

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = FindArticles.new(Article.all).call(params)
    
    # Get all tags ordered by name
    @tags = ActsAsTaggableOn::Tag.order(Arel.sql("lower(name)"))
    
    # put all tags in the URL into an instance var, so they can be used to distinguish which tags are being used in the UI
    if params[:tag].present?
      @active_tags = params[:tag].split(',')
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
    @article.tag_list = flattened_tag_list
    
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
      params.require(:article).permit(:created_by, :name, :url, :description, :article_type, :tag_list)
    end
end
