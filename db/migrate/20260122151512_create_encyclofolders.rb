class CreateEncyclofolders < ActiveRecord::Migration[8.1]
  def change
    create_table :encyclofolders do |t|
      t.timestamps
      t.references :encyclopedium, null: false, foreign_key: true
      t.string :name
      t.datetime :lastupdate
    end
  end
end
