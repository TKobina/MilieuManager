require 'yaml'

# id: 42
# created_at: '2026-01-02T17:54:11.544Z'
# description:
# meaning: nurture
# part: morpheme
# updated_at: '2026-01-02T17:54:11.544Z'
# user_id: 1
# word: b

namespace :lang do
  desc "Create new base user, milieu, language"
  task base: :environment do
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

  task addwords: :environment do
    lexemes = YAML.load_file("#{Rails.root}/lib/yldra/ledru/lexemes.yml")
    lexemes.each do |lexeme|
      next if !lexeme["word"].present?
      Lexeme.create!(
        language: Language.first,
        word: lexeme["word"], 
        meaning: lexeme["meaning"], 
        kind: lexeme["kind"], 
        details: "")
    end

    blank_lexeme = [{"details"=>"","meaning"=>"","kind"=>"","word"=>""}].to_yaml
    File.open("#{Rails.root}/lib/yldra/ledru/lexemes.yml", "w") {|file| file.write(blank_lexeme)}
  end

  task addroots: :environment do
    lexemes = YAML.load_file("#{Rails.root}/lib/yldra/ledru/roots.yml")
    lexemes.each do |lexeme|
      leid = lexeme.keys.first
      next if !leid.present?
      lex = Lexeme.where(eid: leid).first
      lexeme[leid].each do |rootid|
        root = Lexeme.where(eid: rootid).first
        lex.sublexemes << root
      end
    end

    blank_roots = ("- \'\': []\n"*20).as_json.to_yaml
    File.open("#{Rails.root}/lib/yldra/ledru/roots.yml", "w") {|file| file.write(blank_roots)}
  end

  task export: :environment do

  end
end




