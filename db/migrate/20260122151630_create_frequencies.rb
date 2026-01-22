class CreateFrequencies < ActiveRecord::Migration[8.1]
  def change
    create_table :frequencies do |t|
      t.timestamps
      t.references :dialect, null: false, foreign_key: true
      
      t.references :pattern, null: true, foreign_key: true
      t.references :letter, null: true, foreign_key: true
      
      t.string :kind, null: false
      t.integer :n, default: 0
    end
  end
end
