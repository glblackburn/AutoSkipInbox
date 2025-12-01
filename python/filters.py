"""
Helper functions for Gmail filter operations
"""


def get_filters_map(service, user_id):
    """
    Get a map of filter criteria (from addresses) to filter counts
    
    Args:
        service: Gmail API service object
        user_id: User ID (typically 'me')
    
    Returns:
        dict: Map of from address to count
    """
    filters_map = {}
    
    results = service.users().settings().filters().list(userId=user_id).execute()
    filters = results.get('filter', [])
    
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
        print(f"filter.action.remove_label_ids=[{remove_label_ids}]")
        print(f"filter.action.forward=[{forward}]")
        
        filters_map[from_addr] = filters_map.get(from_addr, 0) + 1
    
    return filters_map
