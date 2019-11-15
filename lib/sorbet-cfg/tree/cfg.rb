# typed: true
require_relative 'loc'
require_relative 'type'

module SorbetCFG
  module Tree
    module Instruction; end

    class LocalVariable < T::Struct
      prop :unique_name, String
      prop :type, Type
    end

    class Block < T::Struct
      class BlockExit < T::Struct
        prop :cond, T.nilable(LocalVariable)
        prop :then_block, Integer
        prop :else_block, Integer
        prop :location, Loc
      end

      prop :id, T.nilable(Integer)
      prop :bindings, T::Array[Binding], factory: ->{ [] }
      prop :block_exit, BlockExit
    end

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
      prop :method_name, String
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

    class Binding < T::Struct
      prop :bind, LocalVariable
      prop :value, Instruction
      prop :location, Loc
    end

    class CFG < T::Struct
      class Argument < T::Struct
        prop :name, String
        prop :type, T.nilable(Type)
      end 

      prop :definition_full_name, String
      prop :location, Loc
      prop :return_type, T.nilable(Type)
      prop :arguments, T::Array[Argument]
      prop :blocks, T::Array[Block]

      def self.from_hash(hash)
        res = super(hash)
        res.return_type = Type.from_hash(res.return_type)
        res
      end
    end

    class MultiCFG < T::Struct
      prop :cfg, T::Array[CFG]
    end
  end
end