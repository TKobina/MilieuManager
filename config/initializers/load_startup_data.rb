Rails.application.config.after_initialize do
  # Check if we are running a server (to avoid running during rake tasks like assets:precompile)
  if defined?(Rails::Server) || defined?(Puma::Server) || defined?(Unicorn::Server)

  end
end