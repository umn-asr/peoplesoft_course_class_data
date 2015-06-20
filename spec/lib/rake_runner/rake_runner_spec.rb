require_relative '../../../lib/rake_runner/rake_runner'

RSpec.describe RakeRunner::RakeRunner do

  subject { described_class.new }

  let(:rake_file) { File.expand_path('../../../fixtures/rake_runner_test_tasks.rake',  __FILE__) }

  describe "run" do
    it "raises errors when then task fails" do
      cmd = "bundle exec rake -f #{rake_file} rake_runner_test_tasks:raise_error"
      expect { subject.run(cmd) }.to raise_error(RakeRunner::RakeRunner::RakeError, /error occurred/)
    end

    it "does not raise errors when the task succeeds" do
      cmd = "bundle exec rake -f #{rake_file} rake_runner_test_tasks:success"
      subject.run(cmd)
    end

    it "does not raise errors even with Rake#sh's goofy use of sterr" do
      cmd = "bundle exec rake -f #{rake_file} rake_runner_test_tasks:sh_success"
      subject.run(cmd)
    end
  end

end
