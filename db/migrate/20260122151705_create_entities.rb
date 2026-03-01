class CreateEntities < ActiveRecord::Migration[8.1]
  def change
    create_table :entities do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.references :genvent, null: false, foreign_key: { to_table: :events }
      t.references :language, null: true, foreign_key: true
      t.string :eid, null: false
      t.string :kind
      t.string :name
      t.boolean :public, default: false
    end
  end
end
