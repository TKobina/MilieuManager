class Access < ApplicationRecord
  belongs_to :reader, class_name: 'User', foreign_key: :reader_id
  belongs_to :milieu, class_name: "Milieu", foreign_key: :milieu_id
end

