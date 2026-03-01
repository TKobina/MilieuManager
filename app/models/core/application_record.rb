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
    # def process_csv_upload(product_import)
    #   product_import.csv_file.open do |tempfile|
    #     CSV.foreach(tempfile.path, headers: true) do |row|
    #       # Process each row, e.g., create a database record
    #       Product.create!(
    #         name: row['Name'],
    #         price: row['Price'],
    #         # ... map other attributes
    #       )
    #     end
    #   end
    # end
    path = Rails.root.join('storage/csv/*')
    csvfile = Dir.glob(path).select{|fname| fname.include?(self.name.downcase.pluralize)}.max_by { |f| File.mtime(f) }

    CSV.foreach(csvfile, headers: true, encoding: "utf-8") {|row| self.find_or_create(row.to_hash)}
  end
end
