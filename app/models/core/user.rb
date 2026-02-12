class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :milieus, class_name: 'Milieu', foreign_key: "owner_id", dependent: :destroy
  has_many :accesses, class_name: 'Access', foreign_key: :reader_id
  has_many :readings, through: :accesses, source: :milieu
end