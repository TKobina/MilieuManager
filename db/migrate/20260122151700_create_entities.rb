class CreateEntities < ActiveRecord::Migration[8.1]
  def change
    create_table :entities do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.string :name
      t.string :kind
      t.text :details
      t.date :lastupdate
    end
  end

end
