"""
OAuth2 authorization for Gmail API
"""
import os.path
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

# OAuth2 scopes
SCOPES = [
    'https://www.googleapis.com/auth/gmail.settings.basic',
    'https://www.googleapis.com/auth/gmail.modify'
]

# Paths relative to parent directory (where config folder is located)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CLIENT_SECRETS_PATH = os.path.join(BASE_DIR, 'config', 'client_secret.json')
CREDENTIALS_PATH = os.path.join(BASE_DIR, 'config', 'token.json')


def authorize():
    """
    Ensure valid credentials, either by restoring from the saved credentials
    files or initiating an OAuth2 authorization. If authorization is required,
    the user's default browser will be launched to approve the request.

    Returns:
        Credentials: OAuth2 credentials
    """
    creds = None
    
    # The file token.json stores the user's access and refresh tokens
    if os.path.exists(CREDENTIALS_PATH):
        creds = Credentials.from_authorized_user_file(CREDENTIALS_PATH, SCOPES)
    
    # If there are no (valid) credentials available, let the user log in
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            if not os.path.exists(CLIENT_SECRETS_PATH):
                raise FileNotFoundError(
                    f"Client secrets file not found at {CLIENT_SECRETS_PATH}. "
                    "Please download it from Google Cloud Console."
                )
            flow = InstalledAppFlow.from_client_secrets_file(
                CLIENT_SECRETS_PATH, SCOPES
            )
            creds = flow.run_local_server(port=0)
        
        # Save the credentials for the next run
        os.makedirs(os.path.dirname(CREDENTIALS_PATH), exist_ok=True)
        with open(CREDENTIALS_PATH, 'w') as token:
            token.write(creds.to_json())
    
    return creds
