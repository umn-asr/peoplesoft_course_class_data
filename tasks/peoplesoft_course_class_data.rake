require_relative "../lib/peoplesoft_course_class_data"

namespace :peoplesoft_course_class_data do
  task :download, [:env, :directory] do |t, args|
    args.with_defaults(env: :dev, directory: "tmp")
    PeoplesoftCourseClassData::ClassJsonExport.new(args.env.to_sym, args.directory.to_s).run
  end

  task :copy_good_files, [:source_directory, :target_directory] do |t, args|
    args.with_defaults(source_directory: "tmp", target_directory: "json_tmp")
    files = Rake::FileList[File.join(args.source_directory, "*.json")]

    puts "JSON FILES: #{files.inspect}"

    good_files = files.select do |file|
      json = JSON.parse(File.read(file))
      json["courses"] && json["courses"].count > 0
    end

    puts "GOOD FILES: #{good_files.inspect}"

    good_files.each do |file|
      sh "cp #{file} #{args.target_directory}"
    end
  end

  task :download_and_copy_files, [:env, :xml_dir, :json_dir] do |t, args|
    puts "*** DOWNLOADING COURSE DATA ***"
    Rake::Task["peoplesoft_course_class_data:download"].invoke(args[:env], args[:xml_dir])
    puts "*** COPYING GOOD FILES ***"
    puts "XML DIR: #{args[:xml_dir]}"
    puts "JSON DIR: #{args[:json_dir]}"
    Rake::Task["peoplesoft_course_class_data:copy_good_files"].invoke(args[:xml_dir], args[:json_dir])
    puts "*** DONE ***"
  end
end
