class CreateDialects < ActiveRecord::Migration[8.1]
  def change
    create_table :dialects do |t|
      t.timestamps
      t.references :language, null: false, foreign_key: true
      #t.references :entity, null: false, foreign_key: true
      t.string :name
      t.json :occurrences
      t.json :variances
      #t.integer :n_names
      #t.integer :n_patterns
      #t.integer :n_vowels
      #t.integer :n_bridges
      #t.integer :n_consonants
      #t.float :var_patterns
      #t.float :var_vowels
      #t.float :var_bridges
      #t.float :var_consonants
    end
  end
end
