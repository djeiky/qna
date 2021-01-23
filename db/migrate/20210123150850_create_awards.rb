class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :title
      t.references :question
      t.references :recipient, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
