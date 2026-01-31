class Efolder < ApplicationRecord
  belongs_to :encyclopedium, optional: true
  belongs_to :parent, class_name: "Efolder", optional: true
  has_many :children, class_name: "Efolder", foreign_key: :parent_id, dependent: :destroy
  has_many :efiles, dependent: :destroy 

  after_create_commit :parse_self
  IGNORE = [
     "config.yml"
    ]

  def parse_self
    entries = Dir.entries(File.join(self.path, self.name))
    entries.reject! { |x| IGNORE.include?(x) || x.start_with?(".") || x.start_with?("_") || x==self.name + ".md" }
    entries.each do |entry|
      if File.directory?(File.join(self.path, self.name, entry))
        parse_folder(File.join(self.path, self.name), entry) 
      else
        parse_file(File.join(self.path, self.name), entry) if entry.end_with?(".md")
      end
    end
  end

  def parse_folder(path, name)
    Efolder.find_or_create_by!(encyclopedium: self.encyclopedium, parent: self, path: path, name: name)
  end

  def parse_file(path, name)
    Efile.find_or_create_by!(encyclopedium: self.encyclopedium, efolder: self, path: path, name: name, lastupdate: File.mtime(File.join(path,name)))
  end
end