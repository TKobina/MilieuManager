class Encyclopedium < ApplicationRecord
  belongs_to :milieu
  has_many :efolders, dependent: :destroy
  has_many :efiles

  after_create_commit :parse_root_folder

  
  def parse_root_folder
    puts "Parsing external directories"
    Efolder.find_or_create_by!(encyclopedium: self, path: self.rootdir, name: self.rootfolder)
    puts "Parsing complete"
  end
end
