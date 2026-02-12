class CreateMilieus < ActiveRecord::Migration[8.1]
  def change
    create_table :milieus do |t|
      t.timestamps
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name
      t.text :details
    end
  end
end
