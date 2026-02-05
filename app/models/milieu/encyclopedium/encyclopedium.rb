class Encyclopedium < ApplicationRecord
  belongs_to :milieu
  has_many :efolders, dependent: :destroy
  has_many :efiles

  after_create_commit :parse_root_folder

  
  def parse_root_folder
    Rails.cache.write("personids", [], expires_in: 2.hours)
    puts "Discovering external directories"
    Efolder.find_or_create_by!(encyclopedium: self, path: self.rootdir, name: self.rootfolder)
    puts "Discovery complete"
    progressbar = ProgressBar.create(title: "Parsing files", total: self.efiles.count)
    self.efiles.sort.each{ |efile| efile.proc; progressbar.increment }

    puts "Collecting statistics on names..."
    Rails.cache.read("personids").each {|entid| Entity.find(entid).proc_name}
    ##ISSUES WITH ORDER OF PROCCING
    ##NEED TO PROC EVENTS FIRST, SO LANGUAGES & LETTERS GET BUILT
    ##CHECK SORTING OF DATES
    ##WHY IS NAME GETTING PROCCED BEFORE LANGUAGE?? SORTING HERE SHOULD RESOLVE THAT!
    puts "Parsing complete."
  end
end
