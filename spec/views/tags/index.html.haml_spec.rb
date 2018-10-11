require 'rails_helper'

RSpec.describe "tags/index", type: :view do
  before(:each) do
    assign(:tags, [
      Tag.create!(
        :name => "Name1"
      ),
      Tag.create!(
        :name => "Name2"
      )
    ])
  end

  it "renders a list of tags" do
    pending
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
