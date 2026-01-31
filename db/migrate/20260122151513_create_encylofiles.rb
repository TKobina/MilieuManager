class CreateEncylofiles < ActiveRecord::Migration[8.1]
  def change
    create_table :encylofiles do |t|
      t.timestamps
      t.references :encyclofolders, null: false, foreign_key: true
      t.string :name
      t.datetime :lastupdate
    end
  end
end
