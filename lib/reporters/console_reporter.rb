require 'colorize'

class ConsoleReporter
  def print(matches)
    if matches.any?
      puts "[#{'fail'.red}] #{matches.length} bad files detected."
      matches.each do |match|
        author = match[:commit][:author][:login]
        filename = match[:file][:filename]
        url = match[:commit][:html_url]
        reason = "#{match[:reason][:part]}: #{match[:reason][:content].source}"

        puts "#{author} - #{filename} - #{reason.red} - #{url.blue}"
      end
    else
      puts "[#{'success'.green}] No bad commits."
    end
  end
end