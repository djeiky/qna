# frozen_string_literal: true

class AddUserToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :user, foreign_key: true, index: true
  end
end
