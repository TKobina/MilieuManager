class Efile < ApplicationRecord
  belongs_to :efolder
  has_many :events, dependent: :destroy
end
