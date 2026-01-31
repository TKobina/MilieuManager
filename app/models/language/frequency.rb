class Frequency < ApplicationRecord
  belongs_to :dialect
  belongs_to :letter, optional: true
  belongs_to :pattern, optional: true
end
