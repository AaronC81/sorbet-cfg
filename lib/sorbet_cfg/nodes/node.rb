# typed: true

module SorbetCFG
  module Nodes
    module Node
      extend T::Sig
      extend T::Helpers

      abstract!

      sig { abstract.returns(String) }
      def serialized_name; end
    end
  end
end