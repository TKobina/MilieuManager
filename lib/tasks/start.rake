desc "Initializes the server using host port and ip stored in encrypted credentials"

task "start_closed" => :environment do
  host = Rails.application.credentials.host
  start_command = "rails server -p " + host[:port_closed] + " -b " + host[:ip]
  
  ENV["CURRENT_IP"] = host[:ip]
  ENV["CURRENT_PORT"] = host[:port_open]

  system start_command
end

task "start_open" => :environment do
  host = Rails.application.credentials.host
  aws =  Rails.application.credentials.aws
  start_command = "rails server -p " + host[:port_open] + " -b " + host[:ip] + " -e production"
  ENV["CURRENT_IP"] = host[:ip]
  ENV["CURRENT_PORT"] = host[:port_open]
  ENV["DATABASE_URL"] = host[:url]
  ENV["AWS_ENDPOINT"] = aws[:endpoint]
  ENV["AWS_ACCESS_KEY"] = aws[:access_key]
  ENV["AWS_SECRET_KEY"] = aws[:secret_key]
  ENV["AWS_BUCKET_NAME"] = aws[:bucket_name]

  system start_command
end