
require 'spec_helper'

feature "Manage Pipelines" do
  scenario 'Create a new Pipeline' do
    visit '/manage'
    click_link 'Create new Pipeline'
    fill_in 'name', with: "My Pipeline"
    click_button 'Create'
    page.should have_content('My Pipeline')
  end

  scenario "Add a task to a pipeline" do
    visit '/manage'
    click_link 'Create new Pipeline'
    fill_in 'name', with: "Pipeline with task"
    click_button 'Create'
    click_link 'Add Task'
    fill_in 'name', with: "Run echo cmd"
    fill_in 'command', with: "echo foo"
    click_button 'Create Task'
    page.should have_content("Run echo cmd")
  end
end
