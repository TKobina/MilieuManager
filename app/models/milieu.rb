class Milieu < ApplicationRecord
  belongs_to :user
  
  has_many :entities, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :languages, dependent: :destroy
end
