require 'mailgun'

class EmailReporter
  def initialize(options={})
    @mg_client = Mailgun::Client.new options[:mailgun_api_key]
    @from = options[:from]
    @to = options[:to]
    @subject = options[:subject] || 'Suspicious Commits Spotted!'
    @domain = options[:domain]
  end

  def print(matches)
    if matches.any?
      body = "[fail] #{matches.length} bad files detected.\n"
      matches.each do |match|
        author = match[:commit][:author][:login]
        filename = match[:file][:filename]
        url = match[:commit][:html_url]
        reason = "#{match[:reason][:part]}: #{match[:reason][:content].source}"

        body << "#{author} - #{filename} - #{reason} - #{url}\n"
      end

      # Build the message hash
      message_params = {:from    => @from,
                        :to      => @to,
                        :subject => @subject,
                        :text    => body}

      # Send the message
      @mg_client.send_message @domain, message_params
    end
  end
end