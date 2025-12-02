"""
Helper functions for Gmail label operations
"""


def get_labels_maps(service, user_id):
    """
    Get maps of label names to IDs and IDs to names
    
    Args:
        service: Gmail API service object
        user_id: User ID (typically 'me')
    
    Returns:
        tuple: (nameMap, idMap) where nameMap maps label name to ID,
               and idMap maps label ID to name
    """
    name_map = {}
    id_map = {}
    
    # Show the user's labels
    results = service.users().labels().list(userId=user_id).execute()
    labels = results.get('labels', [])
    
    for label in labels:
        name_map[label['name']] = label['id']
        id_map[label['id']] = label['name']
    
    return name_map, id_map
