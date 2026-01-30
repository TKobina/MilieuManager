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

    unless user2 = User.where(email: tuser[:email]).first
      user2 = User.create!(email: tuser[:email], password: tuser[:password], password_confirmation: tuser[:password])
    end
    
    unless milieu = Milieu.where(user_id: user.id, name: "Ildera").first
      milieu = Milieu.create!(user_id: user.id, name: "Ildera")
    end
     
    puts "Loading and parsing events from Obsidian"
    Event.check_obsidian(Milieu.first)

    puts "Renaming base nation's Language"
    Language.where(name: "Yldr").first.update!(name: "Lëdru")
    
    # houses = YAML.load_file(File.join(Rails.root, paths['houses']))
    # houses.each do |house, properties|
    #   entity = Entity.new(milieu: milieu, kind: "house", name: house)
    #   if !entity.save
    #     puts "Entity failed to save:  #{entity.errors.full_messages.join(', ')}"
    #     next
    #   end
      
    #   property = Property.new(entity: entity, kind: properties['kind'], value: properties['status'])
    #   if !property.save
    #     puts "Property failed to save: #{property.errors.full_messages.join(', ')}"
    #     next
    #   end

    #   entity.properties << property
    # end

    # rel = Relation.new(event: event, superior: Entity.first, inferior: Entity.last, kind: "membership", name: "of")
    # rel.save

  end

  task namegen: :environment do
    1000.times { Dialect.all.sample.generate_name }
  end
end





