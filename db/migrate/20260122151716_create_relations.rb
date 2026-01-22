class CreateRelations < ActiveRecord::Migration[8.1]
  def change
    create_table :relations do |t|
      t.timestamps
      t.references :event, null: false, foreign_key: true
      t.references :superiors, null: true, foreign_key: { to_table: :entities }
      t.references :inferiors, null: true, foreign_key: { to_table: :entities }
      t.string :kind
      t.string :name
      t.text :details
    end
  end
end
