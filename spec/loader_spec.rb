# typed: ignore

require 'fileutils'

RSpec.describe SorbetCFG::Loader do
  LOADER_TEST_DIR = '/tmp/sorbet-cfg-loader-test'

  before :each do
    FileUtils.remove_dir(LOADER_TEST_DIR) if File.exist?(LOADER_TEST_DIR)
    FileUtils.mkdir(LOADER_TEST_DIR)
  end

  describe '#project_root' do
    it 'returns the correct root path for a typical structure' do
      FileUtils.mkdir("#{LOADER_TEST_DIR}/sorbet")
      FileUtils.touch("#{LOADER_TEST_DIR}/Gemfile")
      FileUtils.mkdir("#{LOADER_TEST_DIR}/src")
      FileUtils.mkdir("#{LOADER_TEST_DIR}/src/some_folder")
      FileUtils.touch("#{LOADER_TEST_DIR}/src/some_folder/code.rb")

      expect(described_class.project_root("#{LOADER_TEST_DIR}/src/some_folder/code.rb")).to eq "#{LOADER_TEST_DIR}"
    end

    it 'returns nil when a project is not found' do
      FileUtils.mkdir("#{LOADER_TEST_DIR}/src")
      FileUtils.mkdir("#{LOADER_TEST_DIR}/src/some_folder")
      FileUtils.touch("#{LOADER_TEST_DIR}/src/some_folder/code.rb")

      expect(described_class.project_root("#{LOADER_TEST_DIR}/src/some_folder/code.rb")).to eq nil
    end
  end

  describe '#generate_cfg_export_rbi' do
    it 'generates correct RBIs for accessible classes/modules' do
      expect(described_class.generate_cfg_export_rbi(SorbetCFG::Tree::LocalVariable)).to eq <<-RUBY
module SorbetCFG
  module Tree
    class LocalVariable
      extend T::CFGExport
    end
  end
end
RUBY
    end
  end
end