class CreateCompositions < ActiveRecord::Migration[8.1]
  def change
    create_table :compositions do |t|
      t.timestamps
      t.references :suplexeme_id, null: false, foreign_key: { to_table: :lexemes }
      t.references :sublexeme_id, null: false, foreign_key: { to_table: :lexemes }
    end
  end
end
