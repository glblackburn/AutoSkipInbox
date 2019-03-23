#
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/Filter
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/FilterCriteria
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/FilterAction
#
def getFiltersMaps(service, user_id)
  result = service.list_user_setting_filters(user_id)
  puts 'None found' if result.filter.empty?
  puts "result.filter.count=[#{result.filter.count}]"

  filtersMap=Hash.new(0)

  result.filter.each { |filter| 
    puts "============================================================"
    puts "filter.id=[#{filter.id}]"
    puts "filter.criteria.from=[#{filter.criteria.from}]"
    puts "filter.action.add_label_ids=[#{filter.action.add_label_ids}]"
    puts "filter.action.remove_label_ids=[#{filter.action.remove_label_ids}]"
    puts "filter.action.forward=[#{filter.action.forward}]"
  
    filtersMap[filter.criteria.from] += 1
  }

  return filtersMap
end
