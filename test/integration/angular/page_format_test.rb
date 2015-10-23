require "test_helper"
require 'database_cleaner'

class PageFormatTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    Capybara.current_driver = Capybara.javascript_driver
    sign_out
  end

  def teardown
    DatabaseCleaner.clean
  end

  test 'root path shows sign in, sign up' do
    sleep 2
    visit root_path
    page.has_content?('Please sign in')
    page.has_no_content?('Confirm Password')
    click_on('Sign up!')
    page.has_content?('Confirm Password')
    click_on('Cancel')
  end

  test 'can log in, displays list, sign out' do
    sleep 2
    visit root_path
    fill_in('Enter email', with: 'ruby@example.com')
    fill_in('Password', with: 'password')
    click_on('Submit')
    page.has_content?('Spot Two')
    click_on('Logout')
    click_on('Confirm logout?')
    page.has_content?('Please sign in')
  end

  test 'can log in, create spot' do
    visit root_path
    fill_in('Enter email', with: 'ruby@example.com')
    fill_in('Password', with: 'password')
    click_on('Submit')
    click_on('Quick Spot')
    fill_in('Spot Name', with: 'Hello world!')
    click_on('Create Spot')
    page.has_content?('Hello world!')
    click_on('Logout')
    click_on('Confirm logout?')
  end

  test 'can log in, edit' do
    visit root_path
    fill_in('Enter email', with: 'ruby@example.com')
    fill_in('Password', with: 'password')
    click_on('Submit')
    page.has_no_content?('Hello world!')
    sleep 1.5
    first(:button, 'Options').click
    click_on('Edit')
    fill_in('Notes', with: 'Hello world!')
    click_on('Submit Edit')
    page.has_content?('Hello world!')
    click_on('Logout')
    click_on('Confirm logout?')
  end

  test 'can log in, delete spot' do
    visit root_path
    fill_in('Enter email', with: 'ruby@example.com')
    fill_in('Password', with: 'password')
    click_on('Submit')
    sleep 1.5
    first(:button, 'Options').click
    click_on('Delete')
    click_on('Confirm delete?')
    page.has_no_content?('Notes for one.')
    click_on('Logout')
    click_on('Confirm logout?')
  end

  # test 'click on directions' do
  #   visit root_path
  #   fill_in('Enter email', with: 'ruby@example.com')
  #   fill_in('Password', with: 'password')
  #   click_on('Submit')
  #   sleep 1.5
  #   new_window = window_opened_by { first(:button, 'Directions').click }
  #   sleep 5
  #   within_window new_window do
  #     puts current_url
  #   end
  # end

  # test 'find me button' do
  #   visit root_path
  #   fill_in('Enter email', with: 'ruby@example.com')
  #   fill_in('Password', with: 'password')
  #   click_on('Submit')
  #   click_on('Find Me')
  #   page.has_content?('Republican St')
  #   click_on('Logout')
  # end
end
