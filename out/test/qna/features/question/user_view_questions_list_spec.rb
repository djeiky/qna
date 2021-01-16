require "rails_helper"

feature "Any user can view questions list", %q{
  In order to find question
  As any user
  I wnat to see questions list
} do

  given!(:questions) {create_list(:question, 5)}

  scenario "Any user can see questions list" do
    visit questions_path

    questions.each {|q| expect(page).to have_content q.title}
  end
end
