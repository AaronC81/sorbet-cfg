# typed: true

module SorbetCFG
  module Tree
    class Loc < T::Struct      
      class Position < T::Struct
        class LC < T::Struct
          prop :line, T.nilable(Integer)
          prop :column, T.nilable(Integer)
        end
        
        prop :start, LC
        prop :end, LC
      end

      prop :path, String
      prop :position, Position
    end
  end
end