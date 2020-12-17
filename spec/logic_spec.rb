require 'rails_helper'

RSpec.describe 'Sign in', type: :system do
  describe 'home page' do
    it 'checks the content of the page' do
      visit root_path
      expect(page).to have_content('Sign in')
    end
  end
end

RSpec.feature 'Forms field for Email', type: :feature do
  context 'can enter an email' do
    scenario 'should be Signed in successfully.' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'luffy@onepiece.com'
      end
      click_button 'Log in'
      expect(page).to have_content 'Forgot your password?'
    end
  end
end

RSpec.feature 'Forms field for password', type: :feature do
  context 'can enter a password' do
    scenario 'should be able to enter password.' do
      visit new_user_session_path
      within('form') do
        fill_in 'Password', with: '123456'
      end
      click_button 'Log in'
      expect(page).to have_content 'Sign in'
    end
  end
end

RSpec.feature 'Forms field for password', type: :feature do
  context 'does not have text' do
    scenario 'should not have the succesfull sign in' do
      visit new_user_session_path
      within('form') do
        fill_in 'Password', with: '123456'
      end
      click_button 'Log in'
      expect(page).to_not have_content 'Signed in successfully.'
    end
  end
end
