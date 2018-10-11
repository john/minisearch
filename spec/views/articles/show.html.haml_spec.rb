require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  before(:each) do
    @article = assign(:article, Article.create!(
    :created_by => 1,
    :name => "Name",
    :url => "theURL",
    :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/theURL/)
    expect(rendered).to match(/MyText/)
  end
end
