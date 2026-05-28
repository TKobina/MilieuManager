class AddTextToEntities < ActiveRecord::Migration[8.1]
  def change
    add_column :entities, :text, :jsonb, default: {pri: "", pub: ""}, null: false
  end
end
