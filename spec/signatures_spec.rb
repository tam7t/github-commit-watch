require_relative '../signatures'

describe Signatures do
  describe '#check' do
    let(:sigs) { Signatures.new }

    before do
      sigs << {:part => :patch, :content => /password/}
      sigs << {:part => :filename, :content => /credentials/}
    end

    context 'with matches' do
      context 'with a single match' do
        let(:file) { {filename: 'silly_file.txt', patch:'this is my password'} }

        it 'returns a single match' do
          expect(sigs.check(file)).to eq [{:part => :patch, :content => /password/}]
        end
      end

      context 'with multiple matches' do
        let(:file) { {filename: 'credentials.txt', patch:'this is my password'} }

        it 'returns a single match' do
          expect(sigs.check(file)).to eq [{:part => :patch, :content => /password/}, {:part => :filename, :content => /credentials/}]
        end
      end
    end

    context 'without matches' do
      let(:file) { {filename: 'foo.txt', patch:'bar'} }

      it 'returns a single match' do
        expect(sigs.check(file)).to be_empty
      end
    end
  end
end