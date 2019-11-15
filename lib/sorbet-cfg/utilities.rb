# typed: true

module SorbetCFG
  module Utilities
    extend T::Sig

    sig { params(meth: Method).returns([String, Integer]) }
    def self.true_source_location(meth)
      loc = meth.source_location

      file_path, line = loc
      return loc unless file_path && File.exists?(file_path)

      first_source_line = IO.readlines(file_path)[line - 1]

      # This is how Sorbet replaces methods.
      # If Sorbet undergoes drastic refactorings, this may need to be updated!
      initial_sorbet_line = "T::Private::ClassUtils.replace_method(mod, method_name) do |*args, &blk|"
      replaced_sorbet_line = "mod.send(:define_method, method_sig.method_name) do |*args, &blk|"

      if [initial_sorbet_line, replaced_sorbet_line].include?(T.must(first_source_line).strip)
        T::Private::Methods.signature_for_method(meth).method.source_location
      else
        loc
      end
    end
  end
end