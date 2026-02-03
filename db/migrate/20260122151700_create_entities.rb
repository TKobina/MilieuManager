class CreateEntities < ActiveRecord::Migration[8.1]
  def change
    create_table :entities do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :events, null: true, foreign_key: true
      t.string :eid, null: false
      t.string :kind
      t.string :name
      t.json :text
      t.boolean :public
    end
  end

end
