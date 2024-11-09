# frozen_string_literal: true

require 'spec_helper'

# look at factorybot
describe DatafileBuilder do
  describe '::call' do
    let(:dataload) { create(:dataload) }
    let(:orig_filename) { '/opt/app/spec/support/sandbox/foobar/WJJIYL.json' }

    before do
      @old_pwd = Dir.pwd
      FileUtils.mkdir_p(SANDBOX_DIR)
      FileUtils.cp_r('spec/data', "#{SANDBOX_DIR}/foobar")
    end

    after do
      Dir.chdir(@old_pwd) # rubocop:disable RSpec/InstanceVariable
      FileUtils.rm_rf(SANDBOX_DIR)
    end

    it 'creates a new Datafile' do
      allow(dataload).to receive(:realpath).and_return(Pathname.new('/opt/app/spec/support/sandbox/foobar'))
      described_class.call(orig_filename:, dataload:)
      expect(dataload.datafiles.first).to have_attributes(status: 'in_progress')
    end
  end
end
