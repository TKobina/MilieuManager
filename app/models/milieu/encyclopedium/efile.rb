class Efile < ApplicationRecord
  belongs_to :encyclopedium
  belongs_to :efolder
  has_many :events, dependent: :destroy
  after_create_commit :parse_file
      # filename is a YDATE, for events
      # ## TITLE/HEADING
      # ```
      # proc | event | public/private
      # birth | name | entity eid | gender | parent | parent eid
      # founding | name | entity eid | kind | status | parent eid
      # ```
      # details
      # ~ private details ~`

  def parse_file
    filetext = File.read(File.join(self.path, self.name))
    
    #Break up sections by Headings and EOL
    positions_h = filetext.enum_for(:scan, /^(?:#)(.*)$/).map { Regexp.last_match.begin(0) }
    positions_l = filetext.enum_for(:scan, /\R/).map { Regexp.last_match.begin(0) }
    positions_h.each do |h_0|
      h_1 = positions_h.select { |element| element > h_0 }.first || filetext.length
      t = positions_l.select { |element| element > h_0 }.first || filetext.length

      @heading = filetext[h_0..t].remove("#").strip()
      text = filetext[t..h_1].remove("#").strip()
      i, j  = text.enum_for(:scan, /```/m).map { Regexp.last_match.begin(0) }
      if !i.nil?
        @text = text[j+3..].strip()
        parse_code(text[i+3..j-1].strip())
      end
    end
  end

  def parse_code(code)
    blocks = code.split("\n")
    instruction = blocks[0].split("|").map{ |x| x.strip() }

    return unless instruction[0] == "proc"
    public = instruction[2] == "public"
    
    case instruction[1]
    when "event" then parse_event(blocks[1..].join("\n"), public)
    else parse_block(blocks[1..].join("\n"))
    end
  end

  def parse_block(line)
    p "-----Instruction kind not handled by Efile:------" 
    p line
  end

  def parse_event(blocks, public)
    kinds = []
    blocks.split("\n").map{|x| kinds << x.split("|").map{|y| y.strip()}[0] }
    event = Event.new(kind: kinds.join(","), code: blocks, name: @heading, public: public, efile: self)
    event.milieu = self.encyclopedium.milieu
    event.ydate = event.milieu.get_date_from_strdate(self.name)
    event.details, event.private_details = parse_text
    event.save!
  end

  def parse_text
    i, j  = @text.enum_for(:scan, /~/m).map { Regexp.last_match.begin(0) }
    public = j.nil? ? "" : @text[i+1..j-1].strip()
    private = i.nil? ? @text : @text[0..i-1].strip()
    return [public,private]
  end
end
