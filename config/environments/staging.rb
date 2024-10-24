# This is the same context as the environment.rb file, it is only
# loaded afterwards and only in the production environment

# Change the production log level to debug
# config.log_level = :debug
module ::PeoplesoftCourseClassData
  module Config
    PS_ENV = "qat"
  end
end
