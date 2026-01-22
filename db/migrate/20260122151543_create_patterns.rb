class CreatePatterns < ActiveRecord::Migration[8.1]
  def change
    create_table :patterns do |t|
      t.timestamps
      t.references :language, null: false, foreign_key: true
      
      t.string :pattern

    end
  end
end
