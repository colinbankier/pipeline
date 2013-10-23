require 'capybara'
require 'capybara/rspec'

Capybara.run_server = false
Capybara.app_host = 'http://localhost:4000'
Capybara.default_driver = :selenium
