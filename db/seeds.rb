# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
duser = ENV['DUSER'] #Rails.application.credentials.default_user
dpwd = ENV["DPWD"]
tuser = ENV['TUSER'] #Rails.application.credentials.test_user

#if default user doesn't exist, create it
unless user = User.where(email: duser).first
  user = User.create!(email: duser, password: dpwd, password_confirmation: dpwd)
end

unless user = User.where(email: tuser).first
  user = User.create!(email: tuser, password: dpwd, password_confirmation: dpwd)
end

unless milieu = Milieu.where(owner: user, name: "Ildera").first
  milieu = Milieu.create!(owner: user, name: "Ildera")
end

