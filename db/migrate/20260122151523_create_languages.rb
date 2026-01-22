class CreateLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :languages do |t|
      t.timestamps
      t.references :milieu, null: false, foreign_key: true
      t.string :name
      t.text :details
    end
  end
end
