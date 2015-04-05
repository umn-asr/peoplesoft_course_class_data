namespace :peoplesoft_course_class_data do
  task :download, :env do |t, args|
    args.with_defaults(:env => :dev)
    PeoplesoftCourseClassData::ClassJsonExport.new(args.env.to_sym).run
  end
end