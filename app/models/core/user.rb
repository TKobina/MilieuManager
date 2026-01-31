class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :milieus, dependent: :destroy
  has_many :events, through: :milieu 
  has_many :entities, through: :milieu
  has_many :languages, through: :milieu
end
