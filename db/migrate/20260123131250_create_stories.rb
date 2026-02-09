class CreateStories < ActiveRecord::Migration[8.1]
  def change
    create_table :stories do |t|
      t.timestamps
      t.references :efile, null: true, foreign_key: true
      t.references :milieu, null: false, foreign_key: true
      t.integer :chapter
      t.string :title
      t.boolean :public
      t.text :details
      t.datetime :lastupdate
    end
  end
end
