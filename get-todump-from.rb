#
# helpful script to produce a list of emails from GMail that have the label "autoskipinbox-todump"
#
# run:
# ruby get-todump-from.rb | tee get-todump-from.out
#
require_relative 'authorize.rb'
require_relative 'labels.rb'
require_relative 'filtres.rb'

# Initialize the API
APPLICATION_NAME = 'Gmail API Ruby Quickstart'.freeze
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

user_id = 'me'
labelsNameMap, labelsIdMap = getLabelsMaps(service, user_id)

autoskipLabelId=labelsNameMap["autoskipinbox"]
dumpLabelId=labelsNameMap["autoskipinbox/dump"]
toDumpLabelId=labelsNameMap["autoskipinbox/todump"]
inboxId=labelsNameMap["INBOX"]

puts "inboxId - #{inboxId}"
puts "toDumpLabelId - #{toDumpLabelId}"
puts "dumpLabelId - #{dumpLabelId}"

filterList=getFiltersMap(service, user_id)

fromlist=Hash.new(0)

# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#list_user_messages-instance_method
result = service.list_user_messages(user_id, q: "label:autoskipinbox/todump")
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/ListMessagesResponse
puts "result:=[#{result}]"
if result.messages && !result.messages.empty?
  result.messages.each { |message| 
    puts "-------"
    msg = service.get_user_message(user_id, message.id)
    puts "message.id=[#{message.id}] - msg.label_ids=[#{msg.label_ids}]" 
    msg.label_ids.each { |label| 
      lname=labelsIdMap[label]
      puts "#{label} - #{lname}"
    }
    from=msg.payload.headers.find {|h| h.name == "From" }.value
    puts "#{from}"
    email = ""
    matches = from.match /<(.*)>/
    if matches
      email=matches[1] 
    else
      email=from
    end
    fromlist[email] += 1
    puts "email=[#{email}]"

    # move the message to the dump
    modifyMessageRequest=Google::Apis::GmailV1::ModifyMessageRequest.new
    modifyMessageRequest.add_label_ids=[dumpLabelId]
    modifyMessageRequest.remove_label_ids=[inboxId, toDumpLabelId, autoskipLabelId]
    service.modify_message(user_id, message.id, modifyMessageRequest)
  }
else
  puts 'None found'
end

puts "==============="

puts "------------"
fromlist.keys.each { |email|
  puts "email=[#{email}]"

  if filterList[email] == 0 
    filterAction=Google::Apis::GmailV1::FilterAction.new(add_label_ids: [dumpLabelId], remove_label_ids: [inboxId])
    filterCriteria=Google::Apis::GmailV1::FilterCriteria.new(from: email)
    filter=Google::Apis::GmailV1::Filter.new(action: filterAction, criteria: filterCriteria)
    
    puts "##### Create Filter ## email=[#{email}]"
    puts "filter.action.add_label_ids=[#{filter.action.add_label_ids}]"
    puts "filter.criteria=[#{filter.criteria}]"
    puts "filter.criteria.from=[#{filter.criteria.from}]"
    filterResult = service.create_user_setting_filter(user_id, filter)
  else
    puts "##### Skip it! ## email=[#{email}]"
  end
}
