class CreateProperty < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.timestamps
      t.references :entity, null: false, foreign_key: true      
      t.references :event, null: false, foreign_key: true
      t.json :code
      t.string :kind
      t.string :value
      t.text :detail
      t.boolean :public, default: false
    end
  end
end
