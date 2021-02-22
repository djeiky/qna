require 'rails_helper'

feature 'Vote for answer' do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user can vote up for answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_link('Up')
      expect(page).to have_link('Down')
      click_on "Up"
      expect(page).not_to have_link('Up')
      expect(page).not_to have_link('Down')
      expect(page).to have_link('Vote back')
      expect(page).to have_content('Rating: 1')
    end
  end

  scenario 'Authenticated user can vote down for answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_link('Up')
      expect(page).to have_link('Down')
      click_on "Down"
      expect(page).not_to have_link('Up')
      expect(page).not_to have_link('Down')
      expect(page).to have_link('Vote back')
      expect(page).to have_content('Rating: -1')
    end
  end

  scenario 'Authenticated user can vote back from answer', js: true do
    answer.voteup(user)
    sign_in(user)

    visit question_path(question)
    within '.answers' do
      expect(page).to have_link('Vote back')
      click_on "Vote back"
      expect(page).to have_link('Up')
      expect(page).to have_link('Down')
      expect(page).not_to have_link('Vote back')
      expect(page).to have_content('Rating: 0')
    end
  end

  scenario "Author can't vote for his answer", js: true do
    sign_in(answer.user)
    visit question_path(question)
    within '.answers' do
      expect(page).not_to have_link('Up')
      expect(page).not_to have_link('Down')
    end
  end
end