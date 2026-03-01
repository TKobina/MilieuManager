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
      csv << attributes.join(",").gsub("ydate_id", "ydate_string").split(",")

      all.each do |record|
        fields = []
        attributes.map do |attr|
          if attr == "ydate_id"
            fields << Ydate.find(record.send(attr)).to_s
          else
            fields << record.send(attr).join("<>")
          end
        end
        csv << fields
      end
    end

    File.open(Rails.root.join('storage/csv', filename), "wb", encoding: "utf-8") {|file| file.write(data)}
  end

  def self.from_csv(csvfile = nil)
    csvfile ||=  Rails.root.join("storage","csv","events.csv")
    
    milieus = {}
    ydates = {}
    CSV.foreach(csvfile, headers: true, encoding: "utf-8") do |row|
      if row.headers.include?("ydate_string")
        milieus[row["milieu_id"]] ||= Milieu.find(row["milieu_id"])
        ydates[row["ydate_string"]] ||= Ydate.from_string(milieus[row["milieu_id"]], row["ydate_string"])
        row["ydate_id"] = ydates[row["ydate_string"]].id
        row.delete("ydate_string")
      end
      row["code"] = row["code"].delete("[\"]").split("<>")
      
      event = self.find_or_create_by(row.to_hash)
    end 

    binding.pry
    milieus.values.each {|milieu| milieu.proc_chronology}
  end
end
