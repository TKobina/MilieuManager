class RemoveGenventFromEntities < ActiveRecord::Migration[8.1]
  def change
    remove_column :entities, :genvent_id, :bigint
  end
end
