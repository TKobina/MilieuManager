class EventParamsService
  def self.call(milieu, eparams)
    params = {text: {pri: "", pub: ""}}

    params[:milieu] = milieu
    
    datestring, params[:name], params[:code], details = eparams
    params[:ydate] = Ydate.from_string(milieu, datestring)
    params[:text][:pri], params[:text][:pub], instructions = details.values
    
    params[:code] = "#{params[:code]}\n#{instructions.to_s}".split("\n").map{|x| x.strip}
    cproc, ckind, cpublic = params[:code]&.first&.split("|")
    params[:proc] = cproc == "proc"
    params[:kind] = ckind
    params[:public] = cpublic == "public"
    
    params
  end
end