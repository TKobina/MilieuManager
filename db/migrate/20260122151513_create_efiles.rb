class CreateEfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :efiles do |t|
      t.timestamps
      t.references :encyclopedium, null: false, foreign_key: true
      t.references :efolder, null: false, foreign_key: true
      t.string :name
      t.string :path
      t.datetime :lastupdate
    end
  end
end
