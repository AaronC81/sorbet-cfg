# typed: true
require_relative 'core'
require_relative 'node'

module SorbetCFG
  module Nodes
    class VariableUseSite < T::Struct
      extend T::Sig

      prop :variable, LocalVariable
      prop :type, SorbetType
      
      include Node

      sig { override.returns(String) }
      def serialized_name; 'VariableUseSite'; end
    end
  end
end