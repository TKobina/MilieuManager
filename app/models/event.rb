class Event < ApplicationRecord
  belongs_to :milieu
  has_many :relations
  has_and_belongs_to_many :events
end
