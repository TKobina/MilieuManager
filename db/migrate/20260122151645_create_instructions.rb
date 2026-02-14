class CreateInstructions < ActiveRecord::Migration[8.1]
  def change
    create_table :instructions do |t|
      t.timestamps
      t.references :event, null: false, foreign_key: true
      t.string :kind
      t.string :code
      t.string :description
    end
  end
end
