role :app, %w[asr-courses-prd-web-03.oit.umn.edu]

# Configuration
set :server, "asr-courses-prd-web-03.oit.umn.edu"

server "asr-courses-prd-web-03.oit.umn.edu",
  roles: fetch(:roles),
  ssh_options: {
    user: fetch(:user),
    forward_agent: true,
    auth_methods: %w[publickey]
  }
