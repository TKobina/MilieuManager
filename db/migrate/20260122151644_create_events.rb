class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.references :ydate, null: false, foreign_key: true
      t.string :kind
      t.string :name
      t.text :details
      t.datetime :lastupdate
    end
  end
end
