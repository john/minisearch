require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  before(:each) do
    assign(:articles, [
      Article.create!(
        :created_by => 2,
        :name => "Name",
        :url => "URL",
        :description => "MyText"
      ),
      Article.create!(
        :created_by => 2,
        :name => "Name",
        :url => "Title",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of articles" do
    pending
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
