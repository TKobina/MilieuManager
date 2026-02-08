class CreateLexemes < ActiveRecord::Migration[8.1]
  def change
    create_table :lexemes do |t|
      t.timestamps
      t.references :language, null: false, foreign_key: true
      t.string :word
      t.string :eid
      t.string :kind
      t.string :meaning
      t.text :details
    end
  end
end
