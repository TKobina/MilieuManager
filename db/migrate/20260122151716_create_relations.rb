class CreateRelations < ActiveRecord::Migration[8.1]
  def change
    create_table :relations do |t|
      t.timestamps
      t.references :event, null: false, foreign_key: true
      t.references :relclass, null: false, foreign_key: true
      t.references :superior, null: false, foreign_key: { to_table: :entities }
      t.references :inferior, null: false, foreign_key: { to_table: :entities }
      t.jsonb :text
      t.boolean :public, default: false
    end
  end
end
