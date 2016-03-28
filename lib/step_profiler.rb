require_relative '../config/file_root'

module PeoplesoftCourseClassData
  class StepProfiler
    def self.log(message)
      profile_log = File.join(::PeoplesoftCourseClassData::Config::FILE_ROOT, "log", "step_profile.log")
      File.write(profile_log, "#{Time.now} - #{message}\n", mode: "a+")
    end
  end
end
