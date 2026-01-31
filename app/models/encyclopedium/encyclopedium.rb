class Encyclopedium < ApplicationRecord
  belongs_to :milieu
  has_many :encyclofolders, dependent: :destroy
end
