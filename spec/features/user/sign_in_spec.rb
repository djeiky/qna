require "rails_helper"

feature "User can sign in", %q{
  In order to ask question
  As unauthenticated uer
  I'd like to sign in
} do

  given(:user) {create(:user)}

  background {visit new_user_session_path}

  scenario "Registered user tries to sign in" do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"

    expect(page).to have_content "Signed in successfully."
  end

  scenario "Unregistered user tries to sign in" do
    fill_in "Email", with: "wrong@email.ru"
    fill_in "Password", with: "test123"
    click_on "Log in"

    expect(page).to have_content "Invalid Email or password."
  end
end
