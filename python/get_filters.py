#!/usr/bin/env python3
#
# List all Gmail filters and display their criteria and actions.
#
# run:
# python get_filters.py | tee get-filters.out
#
from googleapiclient.discovery import build
from authorize import authorize
from labels import get_labels_maps

# Initialize the API
APPLICATION_NAME = 'Gmail API Python Quickstart'
service = build('gmail', 'v1', credentials=authorize())

user_id = 'me'
labels_name_map, labels_id_map = get_labels_maps(service, user_id)

print("--------------------------------------------------------------------------------")
results = service.users().settings().filters().list(userId=user_id).execute()
filters = results.get('filter', [])

if not filters:
    print('None found')
else:
    print(f"result.filter.count=[{len(filters)}]")

for filter_obj in filters:
    print("============================================================")
    filter_id = filter_obj.get('id', '')
    criteria = filter_obj.get('criteria', {})
    action = filter_obj.get('action', {})
    
    from_addr = criteria.get('from', '')
    add_label_ids = action.get('addLabelIds', [])
    remove_label_ids = action.get('removeLabelIds', [])
    forward = action.get('forward', '')
    
    print(f"filter.id=[{filter_id}]")
    print(f"filter.criteria.from=[{from_addr}]")
    print(f"filter.action.add_label_ids=[{add_label_ids}]")
    # Uncomment to see label names:
    # for label_id in add_label_ids:
    #     label_name = labels_id_map.get(label_id, '')
    #     print(f"  label_id=[{label_id}] label_name=[{label_name}]")
    print(f"filter.action.remove_label_ids=[{remove_label_ids}]")
    print(f"filter.action.forward=[{forward}]")
