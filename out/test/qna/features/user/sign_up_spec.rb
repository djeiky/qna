require "rails_helper"

feature "User cat sugn_up", %q{
  In order to ask question
  As unauthenticated user
  I want to sign up
} do

  scenario "Unregister user tries to sign up" do
    visit new_user_registration_path

    fill_in "Email", with: "user@email.com"
    fill_in "Password", with: "test123"
    fill_in "Password confirmation", with: "test123"
    click_on "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_path).to eq root_path
  end

  given(:user) {create(:user)}

  scenario "Authenticated user tries to sign up" do
    sign_in user
    visit new_user_registration_path

    expect(page).to have_content "You are already signed in."
  end
end
