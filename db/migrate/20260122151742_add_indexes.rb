class AddIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :languages, :name

    add_index :letters, :sortkey
    add_index :letters, :kind
    add_index :letters, :letter

    add_index :lexemes, :word
 
    add_index :entities, :kind
    add_index :entities, :name
    add_index :entities, [:kind, :name]
    
    add_index :events, :date
    add_index :events, :kind
    add_index :events, [:kind, :date]

    add_index :dialects, :name
    add_index :dialects, [:language_id, :entity_id]

    add_index :relations, :kind
    add_index :relations, :name
    
    add_index :properties, :kind
    add_index :properties, :value

    add_index :patterns, :pattern

    
    #add_foreign_key :relations, :entities, column: :superior_id
    #add_foreign_key :relations, :entities, column: :inferior_id
  end
end
