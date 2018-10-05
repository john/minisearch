require 'rails_helper'

RSpec.describe "articles/edit", type: :view do
  before(:each) do
    @article = assign(:article, Article.create!(
      :created_by => 1,
      :name => "MyString",
      :url => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit article form" do
    render

    assert_select "form[action=?][method=?]", article_path(@article), "post" do

      assert_select "input[name=?]", "article[created_by]"

      assert_select "input[name=?]", "article[name]"

      assert_select "input[name=?]", "article[url]"

      assert_select "textarea[name=?]", "article[description]"
    end
  end
end
