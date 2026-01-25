require 'yaml'

namespace :init do
  desc "Create new base user, milieu, language"
  task base: :environment do
    duser = Rails.application.credentials.default_user
    tuser = Rails.application.credentials.test_user
    paths = Rails.application.credentials.paths

    #if default user doesn't exist, create it
    unless user = User.where(email: duser[:email]).first
      user = User.create!(email: duser[:email], password: duser[:password], password_confirmation: duser[:password])
    end

    unless user = User.where(email: tuser[:email]).first
      user = User.create!(email: tuser[:email], password: tuser[:password], password_confirmation: tuser[:password])
    end

    unless milieu = Milieu.where(user_id: user.id, name: "Yldra").first
      milieu = Milieu.create!(user_id: user.id, name: "Yldra")
    end

    unless language = Language.where(milieu_id: milieu.id, name: "Lëdru").first
      language = Language.create!(milieu_id: milieu.id, name: "Lëdru")
    end

    #generate letters
    alphabet = YAML.load_file(File.join(Rails.root, paths['alphabet']))
    letters_present = language.letters.map{|letter| letter.letter}
    alphabet.each do |kind, letters|
      letters.each do |key, value|
        if !letters_present.include?(key)
          Letter.create!(language_id: language.id, kind: kind, letter: key, sortkey: value)
        end
      end
    end
    
    #generate patterns
    parts = [ "b", "c", "v" ]
    if Pattern.count < 500 
      3.times do |i| 
        perms = parts.repeated_permutation(i + 3).to_a
        perms.each do |perm|
          pattern = Pattern.create(language: language, pattern: perm.join)
          if !pattern.save
            #puts "Pattern failed validation: #{pattern.errors.full_messages.join(', ')}"
          end
        end
      end
    end

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

    #Event.create!(milieu_id: milieu.id, kind: "formation", ydate_id: Ydate.create!(milieu: milieu, date:0).id, summary: "unhoused")
    #Event.create!(milieu: milieu, kind: "birth", ydate_id: Ydate.create!(milieu: milieu, date:0).id, summary: "unknown")
    
    entity = Entity.includes(:milieu).find_or_create_by!(milieu: milieu, kind: "person", name: "unknown")
    property = Property.includes(:entity).find_or_create_by!(entity: entity, kind: "birthdate", value: milieu.get_date_from_intdate(0))
    entity.properties << property

    # rel = Relation.new(event: event, superior: Entity.first, inferior: Entity.last, kind: "membership", name: "of")
    # rel.save
  end
end