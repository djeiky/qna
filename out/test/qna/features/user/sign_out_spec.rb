require "rails_helper"

feature "User can sign out", %q{
  In order to finish working
  As authenticated user
  I'd like to sign out
} do
  given(:user) {create(:user)}
  scenario "Signed in user can log out" do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content "Signed out successfully."
  end
end
