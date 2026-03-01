class CreateReferences < ActiveRecord::Migration[8.1]
  def change
    create_table :references do |t|
      t.timestamps
      t.string :name
      t.references :milieu, null: false, foreign_key: true
      t.string :eid
      t.jsonb :text
    end
  end
end
