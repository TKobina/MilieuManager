class CreateLetters < ActiveRecord::Migration[8.1]
  def change
    create_table :letters do |t|
      t.timestamps
      t.references :language, null: false, foreign_key: true
      t.string :letter
      t.integer :sortkey
      t.string :kind
      t.string :sound
      t.string :details
    end
  end
end
