#!/usr/bin/env python3
#
# Process emails in the Inbox and automatically archive emails that aren't marked
# as "keep-inbox" or "autoskipinbox/tofix". Applies the "autoskipinbox" label
# and removes the "INBOX" label for emails to be archived.
#
# run:
# python autoskipinbox.py | tee autoskipinbox.out
#
import os
import re
from googleapiclient.discovery import build
from authorize import authorize
from labels import get_labels_maps

VERBOSE = False


def verbose_message(message):
    """Print verbose message if verbose mode is enabled"""
    if VERBOSE:
        print(f"verbose: {message}")


def extract_email(from_header):
    """Extract email address from From header"""
    if not from_header:
        return from_header
    
    # Try to match email in angle brackets
    match = re.search(r'<(.*)>', from_header)
    if match:
        return match.group(1)
    return from_header


# Initialize the API
APPLICATION_NAME = 'Gmail API Python Quickstart'
service = build('gmail', 'v1', credentials=authorize())

user_id = 'me'
labels_name_map, labels_id_map = get_labels_maps(service, user_id)

auto_skip_inbox_id = labels_name_map.get("autoskipinbox")
inbox_id = labels_name_map.get("INBOX")

from_list = {}

# List messages in inbox
result = service.users().messages().list(
    userId=user_id, maxResults=500, q="label:inbox"
).execute()

messages = result.get('messages', [])
if not messages:
    print('None found')
else:
    print(f"result.messages.count=[{len(messages)}]")

for message in messages:
    verbose_message("============================================================")
    verbose_message(f"message.id=[{message['id']}]")
    
    msg = service.users().messages().get(userId=user_id, id=message['id']).execute()
    
    # Extract From and Subject headers
    headers = msg['payload'].get('headers', [])
    from_header = next((h['value'] for h in headers if h['name'] == "From"), None)
    subject = next((h['value'] for h in headers if h['name'] == "Subject"), None)
    
    verbose_message(f"from=[{from_header}]")
    verbose_message(f"subject=[{subject}]")
    
    has_tofix = False
    has_keep_inbox = False
    
    label_ids = msg.get('labelIds', [])
    for label_id in label_ids:
        label_name = labels_id_map.get(label_id, '')
        verbose_message(f"{label_id} - {label_name}")
        if label_name == "autoskipinbox/tofix":
            has_tofix = True
            verbose_message("==== match tofix")
        if label_name == "keep-inbox":
            has_keep_inbox = True
            verbose_message("==== match keep-inbox")
    
    if not (has_tofix or has_keep_inbox):
        verbose_message("##################################################")
        verbose_message(f"message.id=[{message['id']}]")
        verbose_message(f"hasKeepInbox=[{has_keep_inbox}]")
        verbose_message(f"hasTofix=[{has_tofix}]")
        verbose_message("-------")
        verbose_message(f"message.id=[{message['id']}] - {label_ids}")
        verbose_message(f"from=[{from_header}]")
        verbose_message(f"subject=[{subject}]")
        
        email = extract_email(from_header)
        from_list[from_header] = from_list.get(from_header, 0) + 1
        
        print(f"move email: email=[{email}] subject=[{subject}]")
        
        # Modify message: add autoskipinbox label, remove inbox label
        modify_request = {
            'addLabelIds': [auto_skip_inbox_id],
            'removeLabelIds': [inbox_id]
        }
        service.users().messages().modify(
            userId=user_id, id=message['id'], body=modify_request
        ).execute()

print("===============")
print("===============")

# Write to log file (in parent directory)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
log_dir = os.path.join(BASE_DIR, 'log')
os.makedirs(log_dir, exist_ok=True)
log_file = os.path.join(log_dir, 'autoskipinbox.txt')
with open(log_file, 'w') as from_file:
    for key in from_list.keys():
        email = extract_email(key)
        print(f"count=[{from_list[key]}] email=[{email}]")
        from_file.write(f"{email}\n")
