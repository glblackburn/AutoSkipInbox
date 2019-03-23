#
# helpful script to produce a list of emails from GMail that have the label "autoskipinbox-tofix"
#
# run:
# ruby autoskipinbox.rb | tee autoskipinbox.out
#
require_relative 'authorize.rb'
require_relative 'labels.rb'


$verbose=false
def verboseMessage(message)
  if $verbose
     puts "verbose: #{message}"
  end
end


# Initialize the API
APPLICATION_NAME = 'Gmail API Ruby Quickstart'.freeze
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

user_id = 'me'
labelsNameMap, labelsIdMap = getLabelsMaps(service, user_id)

autoSkipInboxId=labelsNameMap["autoskipinbox"]
inboxId=labelsNameMap["INBOX"]

fromlist=Hash.new(0)

result = service.list_user_messages(user_id, max_results: 500, q: "label:inbox")
puts 'None found' if result.messages.empty?
puts "result.messages.count=[#{result.messages.count}]"
result.messages.each { |message| 
#  verboseMessage "- #{message.id} - #{message.payload}" 
  verboseMessage "============================================================"
  verboseMessage "message.id=[#{message.id}]"
  msg = service.get_user_message(user_id, message.id)
  from=msg.payload.headers.find {|h| h.name == "From" }.value
  subject=msg.payload.headers.find {|h| h.name == "Subject" }.value
  verboseMessage "from=[#{from}]"
  verboseMessage "subject=[#{subject}]"

  hasTofix=false
  hasKeepInbox=false
  msg.label_ids.each { |label| 
    lname=labelsIdMap[label]
    verboseMessage "#{label} - #{lname}"
    if lname == "autoskipinbox/tofix"
      hasTofix=true
      verboseMessage "==== match tofix"
    end
    if lname == "keep-inbox"
      hasKeepInbox=true
      verboseMessage "==== match keep-inbox"
    end
  }
  if !(hasTofix || hasKeepInbox)
    verboseMessage "##################################################"
    verboseMessage "message.id=[#{message.id}]"
    verboseMessage "hasKeepInbox=[#{hasKeepInbox}]"
    verboseMessage "hasTofix=[#{hasTofix}]"
    verboseMessage "-------"
    verboseMessage "message.id=[#{message.id}] - #{msg.label_ids}" 
    verboseMessage "from=[#{from}]"
    verboseMessage "subject=[#{subject}]"
    fromlist[from] += 1
    email = ""
    matches = from.match /<(.*)>/
    if matches
      email=matches[1] 
    else
      email=from
    end
    puts "move email: email=[#{email}] subject=[#{subject}]"
    # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#modify_message-instance_method

    modifyMessageRequest=Google::Apis::GmailV1::ModifyMessageRequest.new
    modifyMessageRequest.add_label_ids=[autoSkipInboxId]
    modifyMessageRequest.remove_label_ids=[inboxId]
    service.modify_message(user_id, message.id, modifyMessageRequest)
#    exit
  end
}

puts "==============="
puts "==============="

fromfile=File.open('log/autoskipinbox.txt', 'w')

fromlist.keys.each { |key|
  email = ""
  matches = key.match /<(.*)>/
  if matches
    email=matches[1] 
  else
    email=key
  end
  puts "count=[#{fromlist[key]}] email=[#{email}]"
  fromfile.puts "#{email}"
}

fromfile.close
