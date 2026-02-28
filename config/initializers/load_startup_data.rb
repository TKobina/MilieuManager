Rails.application.config.after_initialize do
  # Check if we are running a server (to avoid running during rake tasks like assets:precompile)
  if defined?(Rails::Server) || defined?(Puma::Server) || defined?(Unicorn::Server)
    ActiveRecord::Base.with_connection do
      duser = ENV['DUSER'] #Rails.application.credentials.default_user
      dpwd = ENV["DPWD"]
      tuser = ENV['TUSER'] #Rails.application.credentials.test_user
      
      #if default user doesn't exist, create it
      unless user = User.where(email: duser).first
        user = User.create!(email: duser, password: dpwd, password_confirmation: dpwd)
      end
      
     unless user = User.where(email: tuser).first
        user = User.create!(email: tuser, password: dpwd, password_confirmation: dpwd)
      end

      unless milieu = Milieu.where(owner: user, name: "Ildera").first
        milieu = Milieu.create!(owner: user, name: "Ildera")
      end
    end
  end
end