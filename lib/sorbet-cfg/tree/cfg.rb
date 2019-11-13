# typed: true
require_relative 'instruction'
require_relative 'loc'

module SorbetCFG
  module Tree
    class LocalVariable < T::Struct
      prop :unique_name, String
      prop :type, Type
    end

    class Binding < T::Struct
      prop :bind, LocalVariable
      prop :value, Instruction
      prop :location, Loc
    end

    class Block < T::Struct
      class BlockExit < T::Struct
        prop :cond, T.nilable(LocalVariable)
        prop :then_block, Integer
        prop :else_block, Integer
        prop :location, Loc
      end

      prop :id, Integer
      prop :bindings, T::Array[Binding]
      prop :block_exit, BlockExit
    end

    class CFG < T::Struct
      class Argument < T::Struct
        prop :name, String
        prop :type, Type
      end 

      prop :definition_full_name, String
      prop :location, Loc
      prop :return_type, Type
      prop :arguments, T::Array[Argument]
      prop :blocks, T::Array[Block]
    end

    class MultiCFG < T::Struct
      prop :cfg, T::Array[CFG]
    end
  end
end