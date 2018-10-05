json.extract! article, :id, :created_by, :name, :url, :description, :created_at, :updated_at
json.url article_url(article, format: :json)
