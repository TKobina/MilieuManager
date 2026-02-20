class EventParamsService
  def self.call(milieu, eparams)
    params = {text: {pri: "", pub: ""}}
    datestring, params[:name], params[:code], details = eparams
    params[:text][:pri], params[:text][:pub], instructions = details.values
    params[:code] += "\n" + instructions
    params[:ydate] = Ydate.from_string(milieu, datestring)
    params[:milieu] = milieu
    params
  end
end