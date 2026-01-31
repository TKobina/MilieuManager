module Obsidianold
  extend ActiveSupport::Concern
  require 'yaml'
  #RECEIVES ARRAY OF OBJECTS FROM MODEL
  #Example: receives array of all event objects 
  #BUILDS TREE OF FOLDERNAME DIRECTORY

  #CHECKS FOR PIDS
  #IF FILES EXIST WITHOUT PID'S, ADDS FILEPATH, FILE CONTENTS TO TO_CREATE TREE
  #CHECKS MODIFICATION DATES & COMPARES TO OBJECTS
  #UPDATES & SAVES OBJECTS
  #SENDS TO_CREATE TREE BACK TO MODEL
  @path_obsidian = Rails.root.join(Rails.application.credentials['paths']['Obsidian'])
  @paths = YAML.load_file(File.join(@path_obsidian, "config.yml"))['paths']
  
  def self.proc_records(record_kind, records)
    filetree = fetch_directory(@path_obsidian.join(@paths['Encyclopedia'], @paths[record_kind]), @paths[record_kind])

    return filetree if record_kind == "Events"
    
    files = filetree[:files]  # .keys.map { |filename| File.basename(filename, File.extname(filename)) }
    
    new_files = filter_records(files, records)
  end

  def self.filter_records(files, records)
    #all filenames compared against records
    #files that exist as records as deleted from titles and added to created

    
    # created = {}-
    
    # #GET PID FROM FILE
    # titles.each do |title|
    #   record = records.find{ |x| x.name == title }
    #   created[titles.delete(title)] = record if !record.nil?
    # end

    # update_records(created)

    
    # return titles
    #RETURN FILENAMES, PATH THAT NEED TO BE CREATED AS RECORDS
  end

  def self.update_records(created)
  end

  def self.compare_timestamps(file, event)
    modified = File.mtime(file)
  end

  def self.fetch_directory(path, foldername)
    result = {files: {}, directories: {}}
    entries = Dir.entries(path).reject { |x| x==".." || x=="." || x==foldername + ".md" }
    entries.each do |entry|
      full_path = File.join(path, entry)
      result[test_type(full_path)][entry] = full_path
    end

    result[:directories].each {|name, folderpath| result[:directories][name] = fetch_directory(folderpath, name)}
    result
  end

  def self.test_type(full_path)
    return :files if File.file?(full_path)
    return :directories if File.directory?(full_path)
  end
end

