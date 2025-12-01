# AutoSkipInbox - Python Version

This directory contains the Python implementation of the AutoSkipInbox Gmail automation scripts.

## Overview

The Python scripts provide the same functionality as the Ruby versions:
- **autoskipinbox.py**: Processes emails in the Inbox and automatically archives emails that aren't marked as "keep-inbox" or "autoskipinbox/tofix"
- **get_tofix_from.py**: Processes emails with the "autoskipinbox/tofix" label and creates filters to keep future emails from those addresses in the inbox
- **get_todump_from.py**: Processes emails with the "autoskipinbox/todump" label and creates filters to dump future emails from those addresses
- **get_filters.py**: Lists all Gmail filters
- **get_label_report.py**: Generates a report of unique from addresses for each label

## Prerequisites

- Python 3.7 or higher
- pip (Python package installer)

## Installation

1. **Install Python dependencies:**

   ```bash
   pip install -r requirements.txt
   ```

   Or if you prefer to use a virtual environment (recommended):

   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

2. **Set up Google OAuth credentials:**

   - Go to the [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one
   - Enable the Gmail API for your project
   - Create OAuth 2.0 credentials (Desktop app)
   - Download the credentials JSON file
   - Save it as `../config/client_secret.json` (relative to the python folder)

   For detailed instructions, see:
   https://developers.google.com/gmail/api/quickstart/python

## Configuration

The scripts expect the following directory structure:

```
AutoSkipInbox/
├── config/
│   ├── client_secret.json  # OAuth credentials (you need to download this)
│   └── token.json          # Auto-generated after first authorization
├── log/                     # Log files directory (auto-created)
└── python/
    ├── *.py                 # Python scripts
    └── requirements.txt
```

## First Run / Authorization

The first time you run any script, it will:

1. Open your default web browser
2. Prompt you to sign in to your Google account
3. Ask for permission to access your Gmail account
4. Save the authorization token to `../config/token.json`

**Note:** The token file will be created automatically after the first successful authorization. If you encounter authentication errors, you may need to delete `../config/token.json` and re-authorize.

## Usage

All scripts should be run from the `python` directory:

```bash
cd python
```

### Main Scripts

**Process inbox emails:**
```bash
python autoskipinbox.py | tee autoskipinbox.out
```

**Process tofix emails and create keep-inbox filters:**
```bash
python get_tofix_from.py | tee get-tofix-from.out
```

**Process todump emails and create dump filters:**
```bash
python get_todump_from.py | tee get-todump-from.out
```

**List all Gmail filters:**
```bash
python get_filters.py | tee get-filters.out
```

**Generate label report:**
```bash
python get_label_report.py | tee get-label-report.out
```

## Required Gmail Labels

The scripts expect the following labels to exist in your Gmail account:

- `autoskipinbox` - Label for emails that skip the inbox
- `autoskipinbox/tofix` - Label for emails that need review
- `autoskipinbox/todump` - Label for emails to be dumped
- `autoskipinbox/dump` - Label for dumped emails
- `keep-inbox` - Label to keep emails in inbox

Make sure these labels exist in your Gmail account before running the scripts.

## OAuth Scopes

The scripts require the following Gmail API scopes:
- `https://www.googleapis.com/auth/gmail.settings.basic` - To manage filters
- `https://www.googleapis.com/auth/gmail.modify` - To modify message labels

## Troubleshooting

### Authentication Errors

If you get authentication errors:
1. Delete `../config/token.json`
2. Re-run the script to trigger a new authorization flow

### Missing Labels

If you get errors about missing labels:
1. Create the required labels in Gmail (see "Required Gmail Labels" above)
2. Make sure label names match exactly (case-sensitive)

### Import Errors

If you get import errors:
1. Make sure you've installed all dependencies: `pip install -r requirements.txt`
2. Make sure you're running Python 3.7 or higher: `python3 --version`

## Differences from Ruby Version

- Token file format: Python uses `token.json` instead of `token.yaml`
- File naming: Python files use underscores (e.g., `get_filters.py`) instead of hyphens
- Path handling: Python scripts automatically resolve paths relative to the parent directory

## References

- [Gmail API Python Quickstart](https://developers.google.com/gmail/api/quickstart/python)
- [Gmail API Documentation](https://developers.google.com/gmail/api)
- [Google API Python Client Library](https://github.com/googleapis/google-api-python-client)
