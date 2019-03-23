def getLabelsMaps(service, user_id)
  nameMap = {}
  idMap = {}
  ## Show the user's labels
  r = service.list_user_labels(user_id)
#  puts 'Labels:'
#  puts 'No labels found' if r.labels.empty?
  r.labels.each { |label|
    nameMap[label.name] = label.id
    idMap[label.id] = label.name
#    puts "label.id=[#{label.id}] - label.name=[#{label.name}]"
  }
  return nameMap, idMap
end
