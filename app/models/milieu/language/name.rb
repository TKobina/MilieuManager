class Name < ApplicationRecord
  belongs_to :dialect
  after_create_commit :parse_name

  def self.proc_name_society(name, society, keep: false)
    return if name == "Unknown"
    nn = Name.create!(dialect: society.dialect, value: name)
    nn.destroy! unless keep
    society.superiors.where(kind: ["house", "society", "nation"]).each {|sup| proc_name_society(name, sup)}
    nn
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

      self.dialect.occurrences[kind] = self.dialect.occurrences[kind].to_i + 1
      self.dialect.occurrences["letters"][kind][letter.id] = self.dialect.occurrences["letters"][kind][letter.id].to_i + 1
    end
    pattern = self.dialect.language.patterns.where(value: word_pattern).first
    self.dialect.occurrences["names"] = self.dialect.occurrences["names"].to_i + 1
    self.dialect.occurrences["patterns"][pattern.id] = self.dialect.occurrences["patterns"][pattern.id].to_i + 1
    self.dialect.save
  end
end
