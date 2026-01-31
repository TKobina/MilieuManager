class CreateEncyclopedia < ActiveRecord::Migration[8.1]
  def change
    create_table :encyclopedia do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.string :rootdir
      t.string :rootfolder
    end
  end
end
