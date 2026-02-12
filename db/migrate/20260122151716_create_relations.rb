class CreateRelations < ActiveRecord::Migration[8.1]
  def change
    create_table :relations do |t|
      t.timestamps
      t.references :superior, null: false, foreign_key: { to_table: :entities }
      t.references :inferior, null: false, foreign_key: { to_table: :entities }
      t.references :event, null: false, foreign_key: true
      t.string :code
      t.string :kind
      t.string :name
      t.json :text
      t.boolean :public, default: false
    end
  end
end
