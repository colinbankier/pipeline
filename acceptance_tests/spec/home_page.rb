require 'spec_helper'

feature "Home Page" do
  scenario 'should say hello world' do
    visit '/'
    page.should have_content('Hello, pipeline')
  end
end
