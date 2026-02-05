class Name < ApplicationRecord
  belongs_to :dialect
  after_create_commit :parse_name

  def self.proc_name_society(entity, society)
    Name.create!(dialect: society.dialect, value: entity.name).destroy! unless entity.name == "Unknown"
    society.superiors.where(kind: ["house", "society", "nation"]).each {|sup| proc_name_society(entity, sup)}
  end

  private

  def parse_name
    word_pattern = ""
    self.value.each_char.with_index do |char, index|
      char = char.downcase
      next if char == "h"
      ["w","r","l","y"].each { |bridge| char = "h" + self.value[index] if self.value[index-1] == "h" }
      letter = Letter.where(value: char).first
      kind = letter.kind
      word_pattern += kind[0]

      self.dialect[:occurances][kind] = self.dialect[:occurances][kind].to_i + 1
      self.dialect[:occurances]["letters"][letter.id] = self.dialect[:occurances]["letters"][letter.id].to_i + 1
    end
    pattern = self.dialect.language.patterns.where(value: word_pattern).first
    self.dialect[:occurances]["patterns"][pattern.id] = self.dialect[:occurances]["patterns"][pattern.id].to_i + 1
    self.dialect.save
  end
end
