# typed: true

module SorbetCFG
  module Tree
    class Loc < T::Struct      
      class Position < T::Struct
        class LC < T::Struct
          prop :line, Integer
          prop :column, Integer

          extend T::Sig

          sig { params(hash: Hash).returns(LC) }
          def self.from_hash(hash)
            LC.new(
              line: hash[:line],
              column: hash[:column]
            )
          end
        end
        
        prop :start, LC
        prop :end, LC

        extend T::Sig

        sig { params(hash: Hash).returns(Position) }
        def self.from_hash(hash)
          Position.new(
            start: LC.from_hash(hash[:start]),
            end: LC.from_hash(hash[:end])
          )
        end
      end

      prop :path, String
      prop :position, Position

      extend T::Sig

      sig { params(hash: Hash).returns(Loc) }
      def self.from_hash(hash)
        Loc.new(
          path: hash[:path],
          position: Position.from_hash(hash[:position])
        )
      end
    end
  end
end