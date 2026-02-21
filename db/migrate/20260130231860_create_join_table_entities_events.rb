class CreateJoinTableEntitiesEvents < ActiveRecord::Migration[8.1]
  def change
    create_join_table :entities, :events do |t|
      t.index [:entity_id, :event_id], unique: true
      #t.references :entity, null: false, foreign_key: true
      #t.references :event, null: false, foreign_key: true
    end
  end
end
