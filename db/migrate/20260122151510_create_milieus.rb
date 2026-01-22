class CreateMilieus < ActiveRecord::Migration[8.1]
  def change
    create_table :milieus do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :details
    end
  end
end
