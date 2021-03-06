require 'rails_helper'

RSpec.describe "use_cases/index", type: :view do
  before(:each) do
    assign(:use_cases, [
      UseCase.create!(
        :name => "Name",
        :description => "MyText",
        :project => nil
      ),
      UseCase.create!(
        :name => "Name",
        :description => "MyText",
        :project => nil
      )
    ])
  end

  it "renders a list of use_cases" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
