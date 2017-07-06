require_relative '../test/spec_helper'
require 'logger'
require 'stringio'

require 'kitchen/provisioner/dummy'
require 'kitchen/transport/dummy'
require 'kitchen/verifier/dummy'

describe Kitchen::Driver::Wpar do

  let(:logged_output) { StringIO.new }
  let(:logger) { Logger.new(logged_output) }
  let(:config) { {} }
  let(:platform) { Kitchen::Platform.new(:name => 'fooos-99') }
  let(:suite) { Kitchen::Suite.new(:name => 'suitey') }
  let(:verifier) { Kitchen::Verifier::Dummy.new }
  let(:provisioner) { Kitchen::Provisioner::Dummy.new }
  let(:transport) { Kitchen::Transport::Dummy.new }
  let(:state_file) { double('state_file') }
  let(:state) { Hash.new }
  let(:env) { Hash.new }

  let(:driver_object) { Kitchen::Driver::Wpar.new(config) }

  let(:instance) do
    Kitchen::Instance.new(
        :verifier => verifier,
        :driver => driver_object,
        :logger => logger,
        :suite => suite,
        :platform => platform,
        :provisioner => provisioner,
        :transport => transport,
        :state_file => state_file
    )
  end

  let(:driver) do
    d = driver_object
    instance
    d
  end

  let(:driver_with_no_instance) do
    driver_object
  end


  module RunCommandStub
    def run_command(_cmd, options = {})
      options
    end
  end

  before(:all) do
    Kitchen::Driver::Wpar.instance_eval { include RunCommandStub }
  end

  describe 'configuration' do

    it 'sets :mkwpar name by default' do
      expect(driver[:mkwpar]).to eq('/usr/sbin/mkwpar')
    end

    it 'sets a mkwpar to nil' do
      config[:mkwpar] = nil

      expect(driver[:mkwpar]).to eq(nil)
    end

    it 'sets isWritable to true' do
      config[:isWritable] = true
      default_string = '/usr/sbin/mkwpar -s -n kitchenwpar -l'

      expect(driver.send(:build_mkwpar_command)).to eq(default_string)
    end

    it 'sets wpar_copy_rootvg to true' do
      config[:wpar_copy_rootvg] = true
      default_string = '/usr/sbin/mkwpar -s -n kitchenwpar -t'

      expect(driver.send(:build_mkwpar_command)).to eq(default_string)
    end

    it 'sets isWritable to false' do
      config[:isWritable] = false
      default_string = '/usr/sbin/mkwpar -s -n kitchenwpar'

      expect(driver.send(:build_mkwpar_command)).to eq(default_string)
    end


    it 'sets isVersioned to true' do
      config[:isVersioned] = true
      config[:wpar_mksysb] = 'aix.mksysb'
      default_string = '/usr/sbin/mkwpar -s -n kitchenwpar -C -B aix.mksysb'

      expect(driver.send(:build_mkwpar_command)).to eq(default_string)
    end

    it 'sets isVersioned to false' do
      config[:isVersioned] = false
      config[:wpar_mksysb] = 'aix.mksysb'
      default_string = '/usr/sbin/mkwpar -s -n kitchenwpar -B aix.mksysb'

      expect(driver.send(:build_mkwpar_command)).to eq(default_string)
    end

  end
end
