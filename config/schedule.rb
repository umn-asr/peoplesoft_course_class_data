env :BUNDLE_APP_CONFIG, ENV["BUNDLE_APP_CONFIG"]
env :HOME, ENV["HOME"]
env :MAILTO, "morse255@umn.edu"
env :PS_ENV, ENV["PS_ENV"]
env :TMP_DIR_JSON, "#{ENV["HOME"]}/json_tmp"
env :TMP_DIR_XML, "#{ENV["HOME"]}/tmp"

set :output, {standard: "/proc/1/fd/1"}

every :day, at: "11:00pm" do
  rake "peoplesoft_course_class_data:download_and_copy_files[${PS_ENV},${TMP_DIR_XML},${TMP_DIR_JSON}]"
end
