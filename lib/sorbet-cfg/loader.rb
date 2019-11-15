# typed: true

require 'pathname'
require 'open3'
require 'json'

module SorbetCFG
  module Loader
    extend T::Sig

    sig { returns(T::Hash[T.any(Module, Class), T::Hash[String, Tree::CFG]]) }
    def self.index
      @index ||= {}
    end

    sig { params(a: Integer, b: Integer).returns(Integer) }
    def self.foo(a, b)
      a + b
    end

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

    sig { params(target: T.any(Module, Class)).returns(String) }
    ##
    # Given a module or class, returns the contents of an RBI file which, when
    # loaded, makes that module or class extend T::CFGExport so that Sorbet's
    # "-p cfg-json" option will print JSON for its CFG.
    def self.generate_cfg_export_rbi(target)
      result_lines = []

      # Start from the top
      current_object = T.let(Kernel, T.untyped)

      total_nesting = 0
      target.to_s.split('::').each.with_index do |part_name, i|
        current_object = current_object.const_get(part_name)

        if current_object.is_a?(Class)
          kind = "class"
        elsif current_object.is_a?(Module)
          kind = "module"
        else
          raise "#{current_object} is neither a class nor a module"
        end

        result_lines << "#{'  ' * i}#{kind} #{part_name}"
        total_nesting = i
      end

      result_lines << "#{'  ' * (total_nesting + 1)}extend T::CFGExport"

      (total_nesting + 1).times do |i|
        this_level = total_nesting - i
        result_lines << "#{'  ' * this_level}end"
      end

      result_lines.join("\n") + "\n"
    end 

    sig { params(obj: Module).void }
    def self.index_module(obj)
      rbi_contents = generate_cfg_export_rbi(obj)
      rbi_path = '/tmp/sorbet-cfg-export.rbi'
      File.write(rbi_path, rbi_contents)

      result = T.let(nil, T.nilable(Tree::MultiCFG))

      all_methods = obj.methods + obj.instance_methods
      raise "can\'t get the source location of #{obj} because it contains no methods" if all_methods.empty?

      # Just pick the first one, it's easiest
      # TODO: might be best to pick all unique, though?
      target = obj.method(T.must(all_methods[0]))
      project = project_root(Utilities.true_source_location(target)[0])
      
      raise 'unable to locate project root' unless project

      Open3.popen3('srb', 'tc', rbi_path, '-p', 'cfg-json', chdir: project) do |i, o, e, t|
        json_docs = o.read

        # TODO: VERY BAD
        # Just all of this is terrible
        # There's a stub element at the end because trailing commas aren't valid JSON
        cursed_json_doc = "[#{json_docs.gsub(/^\}/, '},')} null]"
        parsed_json = JSON.parse(cursed_json_doc)[0...-1]
        result = Tree::MultiCFG.new(cfg: parsed_json.map { |x| Tree::CFG.from_hash(x) })
      end

      raise "indexing failed for #{obj}" unless result
      index[obj] = {}
      result.cfg.each do |cfg|
        if cfg.definition_full_name.include?('.')
          prefix_char = '.'
        elsif cfg.definition_full_name.include?('#')
          prefix_char = '#'
        else
          raise "unable to determine type of #{cfg}"
        end

        def_name = "#{prefix_char}#{cfg.definition_full_name.split(prefix_char).last}"
        T.must(index[obj])[def_name] = cfg
      end
    end
  end
end
