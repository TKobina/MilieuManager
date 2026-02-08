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
end





