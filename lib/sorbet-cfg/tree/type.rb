# typed: true

module SorbetCFG
  module Tree
    module Type; end

    class UnknownType < T::Struct
      extend Type
    end

    class ClassType < T::Struct
      extend Type
      prop :class_full_name, String
    end

    class CompositeType < T::Struct
      class Operator < T::Enum
        enums do
          OR = new
          AND = new
        end
      end
      
      extend Type
      prop :left, Type
      prop :right, Type
      prop :operator, Operator
    end

    class AppliedType < T::Struct
      extend Type
      prop :symbol_full_name, String
      prop :type_args, T::Array[Type]
    end

    class ShapeType < T::Struct
      extend Type
      prop :keys, T::Array[Type]
      prop :values, T::Array[Type]
    end

    class LiteralType < T::Struct
      extend Type
      prop :value, T.any(Integer, String, Symbol, T::Boolean, Float)
    end

    class TupleType < T::Struct
      extend Type
      prop :elems, T::Array[Type]
    end
  end
end