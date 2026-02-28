Rails.application.config.after_initialize do
  # Check if we are running a server (to avoid running during rake tasks like assets:precompile)
  if defined?(Rails::Server) || defined?(Puma::Server) || defined?(Unicorn::Server)
    ActiveRecord::Base.with_connection do
      duser = ENV['DUSER'] #Rails.application.credentials.default_user
      tuser = ENV['TUSER'] #Rails.application.credentials.test_user
      
      #if default user doesn't exist, create it
      unless user = User.where(email: duser[:email]).first
        user = User.create!(email: duser[:email], password: duser[:password], password_confirmation: duser[:password])
      end
      
      unless user2 = User.where(email: tuser[:email]).first
        user2 = User.create!(email: tuser[:email], password: tuser[:password], password_confirmation: tuser[:password])
      end

      unless milieu = Milieu.where(owner: user, name: "Ildera").first
        milieu = Milieu.create!(owner: user, name: "Ildera")
      end
    end
  end
end