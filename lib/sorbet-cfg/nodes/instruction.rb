# typed: true
require_relative 'core'

module SorbetCFG
  module Nodes
    module Instruction; end

    # TODO: Alias, requires implementation of SymbolRef

    class Ident < T::Struct
      include Instruction

      prop :what, LocalVariable
    end

    # TODO: SolveConstraint

    class Send < T::Struct
      include Instruction

      prop :recv, VariableUseSite
      prop :fun, SorbetName
      prop :args, T::Array[VariableUseSite]
    end

    class Return < T::Struct
      include Instruction

      prop :what, LocalVariable
    end

    # TODO: BlockReturn

    class LoadSelf < T::Struct
      include Instruction
    end

    class Literal < T::Struct
      include Instruction

      prop :value, String # TODO: literals seem more complicated than this, some how types with values?
    end

    class Unanalyzable < T::Struct
      include Instruction
    end

    class NotSupported < T::Struct
      include Instruction

      prop :why, String
    end

    class LoadArg < T::Struct
      include Instruction

      prop :arg_name, String
    end

    # TODO: LoadYieldParams
    # TODO: Cast
    # TODO: TAbsurd
  end
end