class CreateEfolders < ActiveRecord::Migration[8.1]
  def change
    create_table :efolders do |t|
      t.timestamps
      t.references :encyclopedium, null: true, foreign_key: true
      t.references :efolders, null: true, foreign_key: true
      t.string :name
      t.string :path
      t.datetime :lastupdate
    end
  end
end
