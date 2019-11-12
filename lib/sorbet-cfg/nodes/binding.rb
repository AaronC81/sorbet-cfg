# typed: true
require_relative 'variable_use_site'
require_relative 'instruction'

module SorbetCFG
  module Nodes
    class Binding < T::Struct
      prop :bind, VariableUseSite
      prop :value, Instruction
    end
  end
end