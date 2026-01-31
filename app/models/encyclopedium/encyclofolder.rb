class Encyclofolder < ApplicationRecord
  belongs_to :encyclofolder
  has_many :encyclofiles, dependent: :destroy
end
