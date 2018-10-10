class Article < ApplicationRecord
  acts_as_taggable
  
  enum article_type: [:article, :podcast, :video, :case_study]
  
end
