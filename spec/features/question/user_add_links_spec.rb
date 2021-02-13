require "rails_helper"

feature "User can add links to a question", %q{
  In order to provide additional info
  As an question's author
  I'd like to be able to add links
} do

  describe "Authentiated user", js: true do
    given(:user) { create :user }
    given(:link_url) { "http://ya.ru" }

    background do
      sign_in user
      visit new_question_path

      fill_in "Title", with: "Question title"
      fill_in "Body", with: "Question body"
      click_on "Add link"
      fill_in "Link name", with: "ya.ru"
    end

    scenario "User adds valid link" do
      fill_in "Url", with: link_url
      click_on "Create"

      expect(page).to have_link "ya.ru", href: link_url
    end

    scenario "User trie's to add invalid link" do
      fill_in "Url", with: "invalid"
      click_on "Create"

      expect(page).to have_content "Links url is invalid"
    end

  end
end