RSpec.describe(SorbetCFG::RawParser) do
  let(:subject) { described_class.new }

  describe '#name' do
    it 'parses basic identifiers' do
      %w[foo foo123 Foo123 foo?].each do |x|
        expect(subject.name).to parse x
      end
    end

    it 'parses special identifiers' do
      %w[== =~ | <=>].each do |x|
        expect(subject.name).to parse x
      end
    end

    it 'parses Sorbet reserved names' do
      %w[<statTemp> <ifTemp>].each do |x|
        expect(subject.name).to parse x
      end
    end

    it 'does not parse certain characters' do
      %w[ab,cd ab"cd].each do |x|
        expect(subject.name).not_to parse x
      end
    end
  end
  
  describe '#sorbet_name' do
    it 'parses names' do
      ["<U x>", "<U <statTemp>>"].each do |x|
        expect(subject.sorbet_name).to parse x
      end
    end
  end

  describe '#local_var' do
    it 'parses variables' do
      ["<U x>$4", "<U <statTemp>>$18"].each do |x|
        expect(subject.local_var).to parse x
      end
    end
  end
end