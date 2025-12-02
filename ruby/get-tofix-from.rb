#
# Process emails with the "autoskipinbox-tofix" label:
# - Move messages back to inbox and apply "keep-inbox" label
# - Create Gmail filters for each unique sender to keep future emails in inbox
#
# run:
# ruby get-tofix-from.rb | tee get-tofix-from.out
#
require_relative 'authorize.rb'
require_relative 'labels.rb'
require_relative 'filters.rb'

# Initialize the API
APPLICATION_NAME = 'Gmail API Ruby Quickstart'.freeze
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

user_id = 'me'
labelsNameMap, labelsIdMap = getLabelsMaps(service, user_id)

keepInboxLabelId=labelsNameMap["keep-inbox"]
autoskipLabelId=labelsNameMap["autoskipinbox"]
toFixLabelId=labelsNameMap["autoskipinbox/tofix"]
inboxId=labelsNameMap["INBOX"]

#puts "keepInboxLabelId - #{keepInboxLabelId}"

filterList=getFiltersMap(service, user_id)

fromlist=Hash.new(0)

# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#list_user_messages-instance_method
result = service.list_user_messages(user_id, q: "label:autoskipinbox-tofix")
#result = service.list_user_messages(user_id, q: "label:autoskipinbox-tofix", fields: "payload")
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

    # Move the message to the inbox and add keep-inbox label
    modifyMessageRequest=Google::Apis::GmailV1::ModifyMessageRequest.new
    modifyMessageRequest.add_label_ids=[keepInboxLabelId, inboxId]
    modifyMessageRequest.remove_label_ids=[autoskipLabelId, toFixLabelId]
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
    filterAction=Google::Apis::GmailV1::FilterAction.new(add_label_ids: [keepInboxLabelId])
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
