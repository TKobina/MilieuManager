class EntityEvent < ApplicationRecord
  validates :entity_id, uniqueness: { scope: :event_id }
end