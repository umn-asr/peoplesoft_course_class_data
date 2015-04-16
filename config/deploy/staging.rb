role :app, %w{asr-course-staging.oit.umn.edu}

# Configuration
set :server, 'asr-course-staging.oit.umn.edu'

server 'asr-course-staging.oit.umn.edu',
  roles: fetch(:roles),
  ssh_options: {
    user: fetch(:user),
    forward_agent: true,
    auth_methods: %w(publickey)}

