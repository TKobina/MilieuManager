class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :milieus, dependent: :destroy
  has_many :events, through: :milieus 
  has_many :entities, through: :milieus
  has_many :languages, through: :milieus
end
