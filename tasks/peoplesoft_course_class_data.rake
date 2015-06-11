require_relative '../lib/peoplesoft_course_class_data'

namespace :peoplesoft_course_class_data do
  task :download, [:env, :directory] do |t, args|
    args.with_defaults(:env => :dev, :directory => 'tmp')
    PeoplesoftCourseClassData::ClassJsonExport.new(args.env.to_sym, args.directory.to_s).run
  end

  task :copy_good_files, [:source_directory, :target_directory] do |t, args|
    args.with_defaults(:source_directory => 'tmp', :target_directory => 'json_tmp')
    files = Rake::FileList[File.join(args.source_directory, '*.json')]
    good_files = files.select do |file|
                  json = JSON.parse(File.read(file))
                  json["courses"] && json["courses"].count > 0
                 end

   good_files.each do |file|
     sh "cp #{file} #{args.target_directory}"
   end
  end
end