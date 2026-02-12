class CreateAccesses < ActiveRecord::Migration[8.1]
  def change
    create_table :accesses do |t|
      t.references :milieu, null: false, foreign_key: true
      t.references :reader, null: false, foreign_key: { to_table: :users}
      t.boolean :private_rights, default: false
      t.boolean :edit_rights, default: false
      t.timestamps
    end
  end
end