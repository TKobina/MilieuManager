class CreateRelations < ActiveRecord::Migration[8.1]
  def change
    create_table :relations do |t|
      t.timestamps
      t.references :superior, null: false, foreign_key: { to_table: :entities }
      t.references :inferior, null: false, foreign_key: { to_table: :entities }
      t.string :kind
      t.string :name
      t.text :details
      t.datetime :lastupdate
    end
  end
end
