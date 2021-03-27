require 'rails_helper'

feature 'User can sign in with provider account', %q{
  In order to have several sign in options
  As a user
  I'd like to be able to log in using provider account
} do

  background { visit new_user_session_path }

  describe 'With email' do
    %w[GitHub Vkontakte].each do |provider|

      scenario "User can log in with #{provider} account with correct data" do
        mock_auth_hash(provider)
        silence_omniauth { click_on "Sign in with #{provider}" }

        expect(page).to have_content "Successfully authenticated from #{provider.capitalize} account."
        expect(page).to have_content 'user@usertest.com'
        expect(page).to have_link 'Log out'
      end

      scenario "User can not sign in with #{provider} with invalid data" do
        invalid_mock_auth_hash(provider)
        silence_omniauth { click_on "Sign in with #{provider}" }

        expect(page).to have_content "Could not authenticate you from #{provider} because \"Invalid credentials\"."
        expect(page).to have_link 'Sign in'
        expect(page).to_not have_content 'user@usertest.com'
        expect(page).to_not have_link 'Log out'
      end
    end
  end

  describe 'Without email' do
    scenario 'New user can sign in with Vkontakte account with valid data' do
      mock_auth_vkontakte

      silence_omniauth { click_on 'Sign in with Vkontakte' }
      expect(page).to have_content 'Enter email for confirmation'
      fill_in 'Email', with: 'user@usertest.com'
      click_on 'Confirm email'

      expect(page).to have_content 'Email confirmation instructions send to user@usertest.com'

      open_email 'user@usertest.com'
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      expect(page).to have_content 'user@usertest.com'
      expect(page).to have_link 'Log out'
    end
  end
end
