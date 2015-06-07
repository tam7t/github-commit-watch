require 'reporters/console_reporter'

describe ConsoleReporter do
  describe '#print' do
    before { allow(STDOUT).to receive(:puts) }

    context 'without matches' do
      let(:matches) { [] }

      it 'writes success to standard out' do
        expect(STDOUT).to receive(:puts).with(/success/)
        ConsoleReporter.new.print(matches)
      end
    end

    context 'with matches' do
      let(:reason) { { part: 'patch', content: /password/ } }
      let(:commit) { { author: { login: 'bad_login' }, html_url: 'bad_url' } }
      let(:file) { { filename: 'bad_file' } }

      let(:matches) { [commit: commit, file: file, reason: reason] }

      it 'writes fail to standard out' do
        expect(STDOUT).to receive(:puts).with(/fail/)
        ConsoleReporter.new.print(matches)
      end

      it 'writes the bad commit to standard out' do
        expect(STDOUT).to receive(:puts).with(/bad_file/)
        ConsoleReporter.new.print(matches)
      end
    end
  end
end
