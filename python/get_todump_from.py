#!/usr/bin/env python3
#
# Process emails with the "autoskipinbox/todump" label:
# - Move messages to the dump (apply "autoskipinbox/dump" label, remove inbox/todump labels)
# - Create Gmail filters for each unique sender to automatically dump future emails
#
# run:
# python get_todump_from.py | tee get-todump-from.out
#
import re
from googleapiclient.discovery import build
from authorize import authorize
from labels import get_labels_maps
from filters import get_filters_map

# Initialize the API
APPLICATION_NAME = 'Gmail API Python Quickstart'
service = build('gmail', 'v1', credentials=authorize())

user_id = 'me'
labels_name_map, labels_id_map = get_labels_maps(service, user_id)

autoskip_label_id = labels_name_map.get("autoskipinbox")
dump_label_id = labels_name_map.get("autoskipinbox/dump")
to_dump_label_id = labels_name_map.get("autoskipinbox/todump")
inbox_id = labels_name_map.get("INBOX")

filter_list = get_filters_map(service, user_id)

from_list = {}

# List messages with autoskipinbox/todump label
result = service.users().messages().list(
    userId=user_id, q="label:autoskipinbox/todump"
).execute()

print(f"result:=[{result}]")
messages = result.get('messages', [])

if messages:
    for message in messages:
        print("-------")
        msg = service.users().messages().get(userId=user_id, id=message['id']).execute()
        
        label_ids = msg.get('labelIds', [])
        print(f"message.id=[{message['id']}] - msg.label_ids=[{label_ids}]")
        
        for label_id in label_ids:
            label_name = labels_id_map.get(label_id, '')
            print(f"{label_id} - {label_name}")
        
        # Extract From header
        headers = msg['payload'].get('headers', [])
        from_header = next((h['value'] for h in headers if h['name'] == "From"), None)
        print(f"{from_header}")
        
        email = ""
        if from_header:
            match = re.search(r'<(.*)>', from_header)
            if match:
                email = match.group(1)
            else:
                email = from_header
        
        from_list[email] = from_list.get(email, 0) + 1
        print(f"email=[{email}]")
        
        # Move the message to the dump
        modify_request = {
            'addLabelIds': [dump_label_id],
            'removeLabelIds': [inbox_id, to_dump_label_id, autoskip_label_id]
        }
        service.users().messages().modify(
            userId=user_id, id=message['id'], body=modify_request
        ).execute()
else:
    print('None found')

print("===============")

print("------------")
for email in from_list.keys():
    print(f"email=[{email}]")
    
    if filter_list.get(email, 0) == 0:
        # Create filter
        filter_action = {
            'addLabelIds': [dump_label_id],
            'removeLabelIds': [inbox_id]
        }
        filter_criteria = {
            'from': email
        }
        filter_obj = {
            'action': filter_action,
            'criteria': filter_criteria
        }
        
        print(f"##### Create Filter ## email=[{email}]")
        print(f"filter.action.add_label_ids=[{filter_action['addLabelIds']}]")
        print(f"filter.criteria=[{filter_criteria}]")
        print(f"filter.criteria.from=[{filter_criteria['from']}]")
        filter_result = service.users().settings().filters().create(
            userId=user_id, body=filter_obj
        ).execute()
    else:
        print(f"##### Skip it! ## email=[{email}]")
