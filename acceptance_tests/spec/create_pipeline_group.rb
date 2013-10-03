
require 'spec_helper'

feature "Manage Pipelines" do
  scenario 'Create a new Pipeline' do
    visit '/manage'
    click_link 'Create new Pipeline'
    fill_in 'Name', with: "My Pipeline"
    click_link 'Create'
    page.should have_content('My Pipeline')
  end
end
