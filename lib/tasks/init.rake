require 'yaml'

namespace :init do
  desc "Create new base user, milieu, language"
  task base: :environment do
    Ydate.destroy_all
    Entity.destroy_all
    Event.destroy_all
    Language.destroy_all
    Milieu.destroy_all

    puts "Initializing base users & milieus"
    duser = Rails.application.credentials.default_user
    tuser = Rails.application.credentials.test_user
    paths = Rails.application.credentials.paths

    #if default user doesn't exist, create it
    unless user = User.where(email: duser[:email]).first
      user = User.create!(email: duser[:email], password: duser[:password], password_confirmation: duser[:password])
    end
    # unless user2 = User.where(email: tuser[:email]).first
    #   user2 = User.create!(email: tuser[:email], password: tuser[:password], password_confirmation: tuser[:password])
    # end    
    unless milieu = Milieu.where(user: user, name: "Ildera").first
      milieu = Milieu.create!(user: user, name: "Ildera")
    end
     
    unless encyc = Encyclopedium.where(milieu: milieu).first
      encyc = Encyclopedium.create!(milieu: milieu, rootdir: Rails.root.join("lib"), rootfolder: "obsidian")
    end

  end
  
  task namegen: :environment do
    progressbar = ProgressBar.create(total: 5000)
    5000.times { Dialect.all.sample.generate_name ; progressbar.increment }
  end
end





