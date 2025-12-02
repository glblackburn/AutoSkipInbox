#!/usr/bin/env python3
#
# Generate a report of unique from addresses and their counts for multiple labels:
# inbox, autoskipinbox, autoskipinbox-tofix, autoskipinbox-dump, autoskipinbox-todump
#
# run:
# python get_label_report.py | tee get-label-report.out
#
import re
from googleapiclient.discovery import build
from authorize import authorize


def get_from_count_hash(service, user_id, label):
    """
    Get a count hash of from addresses for messages with a given label
    
    Args:
        service: Gmail API service object
        user_id: User ID (typically 'me')
        label: Label name to filter by
    
    Returns:
        dict: Map of email address to count
    """
    from_list = {}
    
    result = service.users().messages().list(
        userId=user_id, q=f"label:{label}", maxResults=500
    ).execute()
    
    print(f"label:=[{label}]")
    messages = result.get('messages', [])
    
    if messages:
        print(f"result:=[{len(messages)}]")
        for message in messages:
            msg = service.users().messages().get(userId=user_id, id=message['id']).execute()
            
            # Extract From header
            headers = msg['payload'].get('headers', [])
            from_header = next((h for h in headers if h['name'] == "From"), None)
            
            if from_header is None:
                print("msg MISSING from")
                print(msg)
            else:
                from_value = from_header['value']
                email = ""
                match = re.search(r'<(.*)>', from_value)
                if match:
                    email = match.group(1)
                else:
                    email = from_value
                
                from_list[email] = from_list.get(email, 0) + 1
    else:
        print('None found')
    
    return from_list


# Initialize the API
APPLICATION_NAME = 'Gmail API Python Quickstart'
service = build('gmail', 'v1', credentials=authorize())

user_id = 'me'

labels = ["inbox", "autoskipinbox", "autoskipinbox-tofix", "autoskipinbox-dump", "autoskipinbox-todump"]

for label in labels:
    from_hash = get_from_count_hash(service, user_id, label)
    
    for email in from_hash.keys():
        print(f"{{ label:{label}, from:{email}, count:{from_hash[email]} }},")
