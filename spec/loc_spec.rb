# typed: ignore

RSpec.describe(SorbetCFG::Tree::Loc) do
  it 'can be created from a hash' do
    result = described_class.from_hash({
      'path' => './foo.rb',
      'position' => {
        'start' => {
          'line' => 8,
          'column' => 3
        },
        'end' => {
          'line' => 8,
          'column' => 20
        }
      }
    })

    expect(result.path).to eq './foo.rb'
    expect(result.position).to be_a SorbetCFG::Tree::Loc::Position
    expect(result.position.start.column).to eq 3
  end
end