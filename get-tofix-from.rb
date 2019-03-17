#
# helpful script to produce a list of emails from GMail that have the label "autoskipinbox-tofix"
#
# run:
# ruby get-tofix-from.rb | tee get-tofix-from.out
#
require_relative 'authorize.rb'
require_relative 'labels.rb'

# Initialize the API
APPLICATION_NAME = 'Gmail API Ruby Quickstart'.freeze
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

user_id = 'me'
labelsNameMap, labelsIdMap = getLabelsMaps(service, user_id)

result = service.list_user_setting_filters(user_id)
puts 'None found' if result.filter.empty?
puts "result.messages.count=[#{result.filter.count}]"

filterList=Hash.new(0)

result.filter.each { |filter| 
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/Filter
  puts "============================================================"
  puts "filter.id=[#{filter.id}]"
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/FilterCriteria
  puts "filter.criteria.from=[#{filter.criteria.from}]"
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/FilterAction
  puts "filter.action.add_label_ids=[#{filter.action.add_label_ids}]"
  filter.action.add_label_ids.each { |label_id|
    puts "  label_id=[#{label_id}] label_name=[#{labelsIdMap[label_id]}]"
  }
  puts "filter.action.remove_label_ids=[#{filter.action.remove_label_ids}]"
  puts "filter.action.forward=[#{filter.action.forward}]"

  filterList[filter.criteria.from] += 1
}

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
  }
else
  puts 'None found'
end

puts "==============="

keepInboxLabelId=labelsNameMap["keep-inbox"]
puts "keepInboxLabelId - #{keepInboxLabelId}"

puts "------------"
tofix=File.open('log/get-tofix-from.txt', 'w')
fromlist.keys.each { |email|
  puts "email=[#{email}]"
  tofix.puts "#{email}"

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

tofix.close
