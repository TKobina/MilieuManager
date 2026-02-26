class AddIndexes < ActiveRecord::Migration[8.1]
  def change
    add_reference :languages, :nation, null: true, foreign_key: { to_table: :entities }
    add_reference :dialects, :entity, null: false, index: true
    add_reference :entities, :reference, null: true, foreign_key: true

    add_index :dialects, :name
    add_index :dialects, [:language_id, :entity_id]

    add_index :entities, :kind
    add_index :entities, :name
    add_index :entities, :eid
    add_index :entities, [:kind, :name]
    add_index :entities, [:milieu_id, :eid], unique: true

    add_index :events, :name
        
    add_index :languages, :name
    add_index :languages, [:milieu_id, :name], unique: true

    add_index :letters, :sortkey
    add_index :letters, :kind
    add_index :letters, :value
    add_index :letters, [:language_id, :value], unique: true

    add_index :lexemes, :word
    add_index :lexemes, :eid
    add_index :lexemes, [:language_id, :eid], unique: true
    
    add_index :patterns, :value
    
    add_index :properties, :kind
    add_index :properties, :value

    add_index :references, :eid
    add_index :references, [:milieu_id, :eid], unique: true

    add_index :relclasses, [:kind, :topbottom], unique: true

    add_index :ydates, [:milieu_id, :value], unique: true
  end
end
