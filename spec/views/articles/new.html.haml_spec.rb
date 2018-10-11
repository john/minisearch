require 'rails_helper'

RSpec.describe "articles/new", type: :view do
  before(:each) do
    assign(:article, Article.new(
    :created_by => 1,
    :name => "MyString",
    :url => "MyString",
    :description => "MyText"
    ))
  end

  it "renders new article form" do
    pending
    render

    assert_select "form[action=?][method=?]", articles_path, "post" do

      assert_select "input[name=?]", "article[created_by]"

      assert_select "input[name=?]", "article[name]"

      assert_select "input[name=?]", "article[title]"

      assert_select "textarea[name=?]", "article[content]"
    end
  end
end
