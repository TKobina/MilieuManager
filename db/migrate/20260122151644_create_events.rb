class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.references :ydate, null: false, foreign_key: true
      t.integer :i
      t.string :name
      t.string :kind
      t.json :text
      t.json :code
      t.boolean :public, default: false
      t.boolean :proc
    end
  end
end
