class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :created_by
      t.string :name
      t.string :url
      t.integer :article_type
      t.text :description

      t.timestamps
    end
  end
end
