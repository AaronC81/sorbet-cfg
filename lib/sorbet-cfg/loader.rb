# typed: true

require 'pathname'

module SorbetCFG
  module Loader
    extend T::Sig

    sig { params(path: String).returns(T.nilable(String)) }
    ##
    # Given an ABSOLUTE path to somewhere within a Sorbet-enabled Ruby project, 
    # finds the root of the project by looking for a Gemfile or .bundle, as well 
    # as a sorbet directory.
    def self.project_root(path)
      # TODO: Sorbet is currently Unix-only, so this code is too

      raise 'path does not appear to be absolute' unless path.start_with?('/')

      possible_paths = []
      Pathname.new(path).each_filename do |part|
        possible_paths << (possible_paths.empty? \
          ? "/#{part}"
          : File.join(possible_paths.last, part))
      end

      possible_paths.reverse.each do |possible_path|
        has_bundler = File.exist?(File.join(possible_path, 'Gemfile')) ||
          File.exist?(File.join(possible_path, '.bundle'))

        has_sorbet = File.exist?(File.join(possible_path, 'sorbet'))

        return possible_path if has_bundler && has_sorbet
      end

      nil
    end
  end
end
