require_relative '../email_reporter'

describe EmailReporter do
  let(:client) { double('mailgun client') }
  let(:options) { { mailgun_api_key: 'key',
                    from: 'from',
                    to: 'to',
                    subject: 'subject',
                    domain: 'domain'} }

  before do
    allow(Mailgun::Client).to receive(:new) { client }
  end

  it 'initializes the mailgun client with an api key' do
    expect(Mailgun::Client).to receive(:new).with('key')
    EmailReporter.new(mailgun_api_key: 'key')
  end

  describe '#print' do
    context 'without matches' do
      let(:matches) { [] }

      it 'does not send an email' do
        expect(client).to_not receive(:send_message)
        EmailReporter.new(options).print(matches)
      end
    end

    context 'with matches' do
      let(:reason) { { part: 'patch', content: /password/ } }
      let(:commit) { { author: { login: 'bad_login' }, html_url: 'bad_url' } }
      let(:file) { { filename: 'bad_file' } }

      let(:matches) { [commit: commit, file: file, reason: reason] }

      let(:expected_output) do
        [ 'domain', { from:'from', to:'to', subject:'subject', text:"[fail] 1 bad files detected.\nbad_login - bad_file - patch: password - bad_url\n" } ]
      end

      it 'composes a message for mailgun' do
        expect(client).to receive(:send_message).with(*expected_output)
        EmailReporter.new(options).print(matches)
      end
    end
  end
end