#
# Generate a report of unique from addresses and their counts for multiple labels:
# inbox, autoskipinbox, autoskipinbox-tofix, autoskipinbox-dump, autoskipinbox-todump
#
# run:
# ruby get-label-report.rb | tee get-label-report.out
#
require_relative 'authorize.rb'

# Initialize the API
APPLICATION_NAME = 'Gmail API Ruby Quickstart'.freeze
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

user_id = 'me'


def getFromCountHash(service, user_id, label)
  fromlist=Hash.new(0)
  
  result = service.list_user_messages(user_id, q: "label:#{label}", max_results: 500)
  puts "label:=[#{label}]"
  if result.messages && result.messages.size && !result.messages.empty?
    puts "result:=[#{result.messages.size}]"
    result.messages.each { |message| 
#      puts "-------"
      msg = service.get_user_message(user_id, message.id)
#      puts "message.id=[#{message.id}] - msg.label_ids=[#{msg.label_ids}]" 
#      puts "msg.payload.headers=[#{msg.payload.headers}]"
      from=msg.payload.headers.find {|h| h.name == "From" }
#      puts "from=[#{from}]"
#      if from.nil? || from.empty?
      if from.nil?
        puts "msg MISSING from"
	puts msg   
      else
        from_value=from.value
#        puts "from_value=[#{from_value}]"
        email = ""
        matches = from_value.match /<(.*)>/
        if matches
          email=matches[1] 
        else
          email=from
        end
        fromlist[email] += 1
#        puts "email=[#{email}]"
      end
    }
  else
    puts 'None found'
  end
  return fromlist
end

labels=["inbox", "autoskipinbox", "autoskipinbox-tofix", "autoskipinbox-dump", "autoskipinbox-todump"]

labels.each { |label|
  fromHash=getFromCountHash(service, user_id, label)

  fromHash.keys.each { |email|
    puts "{ label:#{label}, from:#{email}, count:#{fromHash[email]} },"
  }
}
