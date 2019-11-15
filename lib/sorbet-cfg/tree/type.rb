# typed: true

module SorbetCFG
  module Tree
    module Type
      extend T::Helpers
      interface!

      def self.from_hash(hash)
        return nil unless hash

        kind = hash['kind']

        if kind == "OR" || kind == "AND"
          result = CompositeType.from_hash(
            hash.merge(operator: CompositeType::Operator.deserialize(kind)))
        end

        result = {
          'CLASS' => ClassType,
          'UNKNOWN' => UnknownType,
          'APPLIED' => AppliedType,
          'LITERAL' => LiteralType,
          'SHAPE' => ShapeType,
          'TUPLE' => TupleType
        }[kind]&.from_hash(hash) || raise("unknown type kind #{hash['kind']}")
      end
    end

    class UnknownType < T::Struct
      include Type
    end

    class ClassType < T::Struct
      include Type
      prop :class_full_name, String
    end

    class CompositeType < T::Struct
      class Operator < T::Enum
        enums do
          OR = new
          AND = new
        end
      end
      
      include Type
      prop :left, Type
      prop :right, Type
      prop :operator, Operator
    end

    class AppliedType < T::Struct
      include Type
      prop :symbol_full_name, String
      prop :type_args, T::Array[Type]
    end

    class ShapeType < T::Struct
      include Type
      prop :keys, T::Array[Type]
      prop :values, T::Array[Type]
    end

    class LiteralType < T::Struct
      include Type
      prop :value, T.any(Integer, String, Symbol, T::Boolean, Float)
    end

    class TupleType < T::Struct
      include Type
      prop :elems, T::Array[Type]
    end
  end
end