# AutoSkipInbox - Ruby Version

This directory contains the Ruby implementation of the AutoSkipInbox Gmail automation scripts.

## Overview

The Ruby scripts provide Gmail inbox automation functionality:
- **autoskipinbox.rb**: Processes emails in the Inbox and automatically archives emails that aren't marked as "keep-inbox" or "autoskipinbox/tofix"
- **get-tofix-from.rb**: Processes emails with the "autoskipinbox/tofix" label and creates filters to keep future emails from those addresses in the inbox
- **get-todump-from.rb**: Processes emails with the "autoskipinbox/todump" label and creates filters to dump future emails from those addresses
- **get-filters.rb**: Lists all Gmail filters
- **get-label-report.rb**: Generates a report of unique from addresses for each label

## Prerequisites

For MacOS, install an updated version of Ruby. Personally, I use Homebrew to install Ruby.

### Homebrew Installation

Homebrew: https://brew.sh/

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Ruby Installation

Ruby: https://www.ruby-lang.org/en/documentation/installation/#homebrew

```bash
brew install ruby
```

**Note**: Homebrew as of 3/19/2019, no longer symlinks ruby into /usr/local/bin. The new path to ruby is '/usr/local/opt/ruby/bin'.

If you need to have ruby first in your PATH run:
```bash
echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.bash_profile
```

## Installation

### Using install.sh

The installer will do the following:
* Detect ruby in your path
* Check the version
* Install the needed gems
* Add "run-it.sh" to your crontab

To install, run the `install.sh` script from the ruby directory:

```bash
cd ruby
./install.sh
```

### Manual Installation

1. **Install rbenv (optional but recommended):**

   ```bash
   brew install rbenv
   rbenv install
   ```

2. **Install Ruby gems:**

   ```bash
   gem install google-api-client -v '~> 0.8'
   ```

3. **Set up Google OAuth credentials:**

   - Go to the [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one
   - Enable the Gmail API for your project
   - Create OAuth 2.0 credentials (Desktop app)
   - Download the credentials JSON file
   - Save it as `../config/client_secret.json` (relative to the ruby folder)

   For detailed instructions, see:
   https://developers.google.com/gmail/api/quickstart/ruby

## Configuration

The scripts expect the following directory structure:

```
AutoSkipInbox/
├── config/
│   ├── client_secret.json  # OAuth credentials (you need to download this)
│   └── token.yaml          # Auto-generated after first authorization
├── log/                     # Log files directory (auto-created)
└── ruby/
    ├── *.rb                 # Ruby scripts
    ├── *.sh                 # Shell scripts
    └── Makefile
```

## Usage

All scripts should be run from the `ruby` directory:

```bash
cd ruby
```

### Using Makefile

**Run the main script:**
```bash
make run
```

**Setup (install rbenv and gems):**
```bash
make setup
```

### Using Scripts Directly

**Process inbox emails:**
```bash
ruby autoskipinbox.rb
```

**Process tofix emails:**
```bash
ruby get-tofix-from.rb
```

**Process todump emails:**
```bash
ruby get-todump-from.rb
```

**List all Gmail filters:**
```bash
ruby get-filters.rb
```

**Generate label report:**
```bash
./get-label-report.sh
```

**Run all scripts (wrapper):**
```bash
./run-it.sh
```

## run-it.sh

run-it.sh is the wrapper script that is setup in cron. This script:
- Calls `autoskipinbox.rb` and `get-tofix-from.rb`
- Captures the output from the ruby scripts into a datetime stamped run log
- Processes the run log for summary statistics that are saved in `autoskipinbox.log`

**Note**: run-it.sh does not depend on the PATH variable, because this script is run from cron. The RUBY_PATH variable needs to be updated to the install location for the version of ruby you are using.

## Required Gmail Labels

The scripts expect the following labels to exist in your Gmail account:

- `autoskipinbox` - Label for emails that skip the inbox
- `autoskipinbox/tofix` - Label for emails that need review
- `autoskipinbox/todump` - Label for emails to be dumped
- `autoskipinbox/dump` - Label for dumped emails
- `keep-inbox` - Label to keep emails in inbox

Make sure these labels exist in your Gmail account before running the scripts.

## Troubleshooting

### gem install permission issue

On macOS Mojave with the default ruby install the below error will display when running `gem install google-api-client -v '~> 0.8'`:

```
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /Library/Ruby/Gems/2.3.0 directory.
```

Solution: https://stackoverflow.com/questions/14607193/installing-gem-or-updating-rubygems-fails-with-permissions-error

### Authentication Errors

If you get authentication errors:
1. Delete `../config/token.yaml`
2. Re-run the script to trigger a new authorization flow

**Note**: Remove token.yaml when there is an authentication error. Could be a timeout issue.

## References

### Gmail API for Ruby
- [Google Gmail API Quickstart](https://developers.google.com/gmail/api/quickstart/ruby)
- [Install the Google Client Library](https://developers.google.com/gmail/api/quickstart/ruby)

### Ruby Documentation
- [Rubydoc - Gmail V1 API](https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1)
- [GmailService - list_user_messages](https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#list_user_messages-instance_method)
- [GmailService - get_user_message](https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#get_user_message-instance_method)
- [ListMessagesResponse](https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/ListMessagesResponse#messages-instance_method)
- [Message](https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/Message)

### Examples
- [Example Gmail API usage](https://gist.github.com/jkotchoff/34fba5c6df03a5caadad286b80c97b96#file-emailed_zip_file_extractor-rb-L81)
