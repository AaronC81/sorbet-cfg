# typed: true

module SorbetCFG
  module Tree
    module Instruction; end

    class UnknownInstruction < T::Struct
      extend Instruction
    end

    class IdentInstruction < T::Struct
      extend Instruction
      prop :ident, LocalVariable
    end

    class AliasInstruction < T::Struct
      extend Instruction
      prop :alias_full_name, String
    end

    class SendInstruction < T::Struct
      extend Instruction
      prop :receiver, LocalVariable
      prop :method, String
      prop :arguments, T::Array[LocalVariable]
      prop :block, Block
    end

    class ReturnInstruction < T::Struct
      extend Instruction
      prop :return, LocalVariable
    end

    class LiteralInstruction < T::Struct
      extend Instruction
      prop :literal, Type
    end

    class UnanalyzableType < T::Struct
      extend Instruction
    end

    class LoadArgType < T::Struct
      extend Instruction
      prop :load_arg_name, String
    end

    class CastInstruction < T::Struct
      extend Instruction
      prop :value, LocalVariable
      prop :type, Type
    end
  end
end