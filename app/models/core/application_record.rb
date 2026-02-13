class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  
  #require 'csv'

  MODELS = [
    "User",
    "Milieu",
    "Encyclopeda",
    "Language",
    "Letter",
    "Pattern",
    "Lexeme",
    "Dialect",
    "Composition",
    "Ydate",
    "Event",
    "Story"
  ]

  #Class.const_get("User")

  def self.to_csv
    attributes = self.column_names - ["id", "created_at", "updated_at"]
    filename = "#{self.name.downcase.pluralize}-#{Date.today}.csv"

    data = CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |record|
        csv << attributes.map { |attr| record.send(attr) }
      end
    end

    File.open(Rails.root.join('storage/csv', filename), "wb", encoding: "utf-8") {|file| file.write(data)}
  end

  def self.from_csv
    path = Rails.root.join('storage/csv/*')
    csvfile = Dir.glob(path).select{|fname| fname.include?(self.name.downcase.pluralize)}.max_by { |f| File.mtime(f) }

    CSV.foreach(csvfile, headers: true, encoding: "utf-8") {|row| self.create!(row.to_hash)}
  end
end
