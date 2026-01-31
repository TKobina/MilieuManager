class CreateEntities < ActiveRecord::Migration[8.1]
  def change
    create_table :entities do |t|
      t.timestamps
      t.references :event, null: false, foreign_key: true
      t.string :code
      t.string :kind
      t.string :name
      t.text :details
      t.text :private_details
      t.boolean :public
    end
  end

end
