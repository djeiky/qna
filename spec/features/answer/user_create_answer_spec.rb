require "rails_helper"

feature "User can create answer for a question", %q{
  In order to answer question
  I need to fill form on question page
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe "Authenticated user", js:true do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "creates answer" do
      within "#new-answer-form" do
        fill_in "Body", with: "New Answer"
        click_on "Create Answer"
      end

      expect(current_path).to eq question_path(question)
      within ".answers" do
        expect(page).to have_content "New Answer"
      end
    end

    scenario "tries to create answer with invalid params" do
      click_on "Create Answer"

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to create answer with attached files" do
      within "#new-answer-form" do
        fill_in "Body", with: "New Answer"
        attach_file "Files", %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on "Create Answer"
      end

      within ".answers" do
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end

    scenario "multiply sessions, answer appears in another user's session", js: true do
      Capybara.using_session("guest") do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
        within "#new-answer-form" do
          fill_in "Body", with: "New Answer"
          click_on "Create Answer"
        end
      end

      Capybara.using_session('guest') do
        within ".answers" do
          expect(page).to have_content "New Answer"
        end
      end
    end
  end

  scenario "Unauthenticated user" do
    visit question_path(question)
    within "#new-answer-form" do
      fill_in "Body", with: "Answer Body"
      click_on "Create Answer"
    end

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
