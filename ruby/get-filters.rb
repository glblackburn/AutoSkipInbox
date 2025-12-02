#
# List all Gmail filters and display their criteria and actions.
#
# run:
# ruby get-filters.rb | tee get-filters.out
#
require 'fileutils'
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

# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#list_user_setting_filters-instance_method
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/ListFiltersResponse
puts "--------------------------------------------------------------------------------"
result = service.list_user_setting_filters(user_id)
puts 'None found' if result.filter.empty?
puts "result.filter.count=[#{result.filter.count}]"

result.filter.each { |filter| 
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/Filter
  puts "============================================================"
  puts "filter.id=[#{filter.id}]"
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/FilterCriteria
  puts "filter.criteria.from=[#{filter.criteria.from}]"
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/FilterAction
  puts "filter.action.add_label_ids=[#{filter.action.add_label_ids}]"
#  filter.action.add_label_ids.each { |label_id|
#    puts "  label_id=[#{label_id}] label_name=[#{labelsIdMap[label_id]}]"
#  }
  puts "filter.action.remove_label_ids=[#{filter.action.remove_label_ids}]"
  puts "filter.action.forward=[#{filter.action.forward}]"
}
