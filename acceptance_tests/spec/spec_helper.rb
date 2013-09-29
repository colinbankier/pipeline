require 'capybara'
require 'capybara/rspec'

Capybara.run_server = false
Capybara.app_host = 'http://localhost:8080'
Capybara.default_driver = :selenium