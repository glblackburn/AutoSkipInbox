#
# helpful script to produce a list of emails from GMail that have the label "autoskipinbox-tofix"
#
# run:
# ruby get-tofix-from.rb | tee get-tofix-from.out
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
  messageCount=0
  missingFromCount=0
  
  result = service.list_user_messages(user_id, max_results: 1000, q: "label:#{label}")
#  puts "result:=[#{result}]"
  if result.messages && !result.messages.empty?
    result.messages.each { |message|
      messageCount += 1
#      puts "-------"
      msg = service.get_user_message(user_id, message.id)
#      puts "message.id=[#{message.id}] - msg.label_ids=[#{msg.label_ids}]"
      from_header=msg.payload.headers.find {|h| h.name == "From" }
      if from_header.respond_to?(:value)
        from=from_header.value
#      puts "#{from}"
        email = ""
        matches = from.match /<(.*)>/
        if matches
          email=matches[1] 
        else
          email=from
        end
        fromlist[email] += 1
      else
        puts "getFromCountHash: message missing From.value: message.id=[#{message.id}] - msg.label_ids=[#{msg.label_ids}]"
        missingFromCount += 1
      end
#      puts "email=[#{email}]"
    }
  else
#    puts 'None found'
  end
  puts "getFromCountHash: messageCount=[#{messageCount}] missingFromCount=[#{missingFromCount}] user_id=[#{user_id}] label=[#{label}] result_size_estimagte=[#{result.result_size_estimate}]"
  return fromlist
end

labels=["inbox", "autoskipinbox", "autoskipinbox-tofix", "autoskipinbox-dump", "autoskipinbox-todump"]

labels.each { |label|
  fromHash=getFromCountHash(service, user_id, label)

  fromHash.keys.each { |email|
    puts "{ label:#{label}, count:#{fromHash[email]}, from:#{email} },"
  }
}
