require "rails_helper"

feature "User can add links to a answers", %q{
  In order to provide additional info
  As an answer's author
  I'd like to be able to add links
} do

  describe "Authenticated user", js: true do

    given(:user) { create :user }
    given!(:question) { create :question }
    given(:link_url) { "http://ya.ru" }

    background do
      sign_in user
      visit question_path(question)

      within "#new-answer-form" do
        fill_in "Body", with: "New Answer"
        click_on "Add link"
        fill_in "Link name", with: "ya.ru"
      end
    end

    scenario "User adds valid link" do
      within "#new-answer-form" do
        fill_in "Url", with: link_url

        click_on "Create Answer"
      end
      within ".answers" do
        expect(page).to have_link "ya.ru", href: link_url
      end
    end

    scenario "User adds valid link", js: true do
      within "#new-answer-form" do
        fill_in "Url", with: "invalid"

        click_on "Create Answer"
      end
      expect(page).to have_content "Links url is invalid"
    end
  end
end