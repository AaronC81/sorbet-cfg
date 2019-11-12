# typed: true

module SorbetCFG
  module Nodes
    class LocalVariable < T::Struct
      prop :name, SorbetName
      prop :unique, Integer
    end

    class SorbetType < T::Struct
      prop :value, String
    end

    class SorbetNameKind < T::Enum
      enums do
        Utf8 = new
        Unique = new
        Constant = new
      end
    end

    class SorbetUniqueNameKind < T::Enum
      enums do
        Parser                = new 'P'
        Desugar               = new 'D'
        Namer                 = new 'N'
        MangleRename          = new 'M'
        Singleton             = new 'S'
        Overload              = new 'O'
        TypeVarName           = new 'T'
        PositionalArg         = new 'A'
        MangledKeywordArg     = new 'K'
        ResolverMissingClass  = new 'R'
        OpusEnum              = new 'E'
        DefaultArg            = new 'DA'
      end
    end

    class SorbetName < T::Struct
      prop :kind, SorbetNameKind
      prop :unique_kind, T.nilable(SorbetUniqueNameKind)
      prop :value, String
    end
  end
end
