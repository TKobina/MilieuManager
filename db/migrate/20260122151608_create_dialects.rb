class CreateDialects < ActiveRecord::Migration[8.1]
  def change
    create_table :dialects do |t|
      t.timestamps
      t.references :language, null: false, foreign_key: true
      t.string :name
      t.jsonb :occurrences
      t.jsonb :variances
    end
  end
end
