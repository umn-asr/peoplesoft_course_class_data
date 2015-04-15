require_relative '../lib/class_json_export'

namespace :peoplesoft_course_class_data do
  task :download, [:env, :directory] do |t, args|
    args.with_defaults(:env => :dev, :directory => 'tmp')
    PeoplesoftCourseClassData::ClassJsonExport.new(args.env.to_sym, args.directory.to_s).run
  end
end