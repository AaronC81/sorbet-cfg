# typed: false
require 'parslet'

module SorbetCFG
  class RawParser < Parslet::Parser
    # As far as I can tell, it's OK to just shotgun most operators, but < and >
    # need special care because they delimit #sorbet_name
    # There's probably some absolutely horrendous stuff that this accepts, but
    # if that sort of stuff occurs in a CFG, we have bigger problems
    rule(:name)         { match('[A-Za-z_0-9=\-|&.!~?]').repeat(1) |
                          (str('<') >> name >> str('>') | # Matches <=> too!
                          str('>') | str('<') | str('<=') | str('>=')) }
    
    rule(:space)        { match('\s').repeat(1) }
    rule(:space?)       { space.maybe }

    rule(:langle)       { space? >> match('<') >> space? }
    rule(:rangle)       { space? >> match('>') >> space? }

    rule(:lbrace)       { space? >> match('{') >> space? }
    rule(:rbrace)       { space? >> match('}') >> space? }

    rule(:sorbet_name)  { langle >>
                          match('[A-Z]').repeat(1).as(:kind) >>
                          space? >>
                          name.as(:value) >>
                          rangle }

    rule(:local_var)    { sorbet_name.as(:name) >>
                          str('$') >>
                          match('[0-9]').repeat(1).as(:unique) >>
                          space? }

    rule(:node)         { identifier.as(:type) >> lbrace >> rbrace }
    root(:node)
  end
end