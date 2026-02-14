require 'yaml'

namespace :init do
  desc "Create new base user, milieu, language"
  task base: :environment do
    #Ydate.destroy_all
    #Entity.destroy_all
    #Event.destroy_all
    #Language.destroy_all
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

    unless milieu = Milieu.where(owner: user, name: "Ildera").first
      milieu = Milieu.create!(owner: user, name: "Ildera")
    end

    current_user.readings << milieu
     
    ObsidianImporterService.new(Rails.root.join("lib"), "obsidian", milieu)

    #Dialect.first.generate_name

    Lexeme.destroy_all

    lexemes = YAML.load_file("#{Rails.root}/lib/backup_lexemes.yml")
    progressbar = ProgressBar.create(title: "Importing Lexemes", total: lexemes.count)
    lexemes.each do |lexeme|
      Lexeme.create!(
        language: Language.first,
        word: lexeme["word"], 
        meaning: lexeme["meaning"], 
        kind: lexeme["part"], 
        details: lexeme["description"],
        eid: lexeme["eid"])
        progressbar.increment
    end
  end
  
  task namegen: :environment do
    progressbar = ProgressBar.create(total: 5)
    5.times { Dialect.all.each { |dia| dia.generate_name } ; progressbar.increment }
  end

  task proc_old_events: :environment do
    events = YAML.load_file("#{Rails.root}/lib/backup_events.yml").each do |event|
      ydate = Ydate.to_s(event["edate"])
      kind = event["etype"]
      dets = event["details"]

      File.open("#{Rails.root}/lib/obsidian/World/Encyclopedia/Events/" + ydate + ".md", 'a') do |file|
        file.puts "---\nkind: date\n---\n# Birth of Ŧëc Amdëlu\n```\nproc | event | public\nbirth | Amdëlu | wr | unknown | Ŧëc\n```"
        file.puts "\n#{kind}: #{dets}"
      end
    end
  end
end





