role :app, %w{asr-course-staging.oit.umn.edu}

# Configuration
set :user, 'swadm'
set :server, 'asr-course-staging.oit.umn.edu'
set :roles, %w{app}
set :app_root, '/swadm/apps/peoplesoft_course_class_data'
set :deploy_to, "#{fetch(:app_root)}"

server 'asr-course-staging.oit.umn.edu',
  roles: fetch(:roles),
  ssh_options: {
    user: fetch(:user),
    forward_agent: true,
    auth_methods: %w(publickey)}

