# Getting Started

## Overview

TODO

## Release Notes

### Version 2.0.0 - Python Implementation (2025-12-01)
- 🐍 **New**: Complete Python implementation added alongside Ruby
- 📁 **New**: Project reorganized into `python/` and `ruby/` directories
- 🔒 **Security**: Credentials moved to `~/.secure/AutoSkipInbox/` for Python version
- 🛠️ **New**: Python Makefile with pyenv support
- 📚 **New**: Comprehensive Python documentation

For detailed release notes, see [RELEASE_NOTES.md](RELEASE_NOTES.md).

### Previous Releases
- **Version 1.0.0**: Initial Ruby release with Gmail API integration

## Installation

This project provides both Ruby and Python implementations. Choose the one that best fits your needs.

### Ruby Implementation

For Ruby installation and usage instructions, see [ruby/README.md](ruby/README.md).

Quick start:
```bash
cd ruby
./install.sh
```

### Python Implementation

For Python installation and usage instructions, see [python/README.md](python/README.md).

Quick start:
```bash
cd python
make setup
```

# TODO
* figure out how to do google auth as part of install.  there is a step past saving the client_secret.json file that prompts as part of the auth.
* add overview
* document how to used once installed
* update installer to validate ruby version
* DONE: document shell and ruby scripts
* DONE: update installer to install ruby gems

# Scripts

## Ruby Scripts

For detailed information about Ruby scripts, see [ruby/README.md](ruby/README.md).

- **autoskipinbox.rb**: Processes emails in the Inbox. Any email that is not marked as "keep-inbox" or "autoskipinbox/tofix" will be archived and the "autoskipinbox" label will be applied.
- **get-tofix-from.rb**: Processes emails with the label "autoskipinbox/tofix" and creates filters to keep future emails from those addresses in the inbox.
- **get-todump-from.rb**: Processes emails with the label "autoskipinbox/todump" and creates filters to dump future emails from those addresses.
- **get-filters.rb**: Lists all Gmail filters.
- **get-label-report.rb**: Pulls counts of unique from addresses with each label used.
- **run-it.sh**: Wrapper script that calls autoskipinbox.rb and get-tofix-from.rb, captures output into timestamped logs, and processes summary statistics.

## Python Scripts

For detailed information about Python scripts, see [python/README.md](python/README.md).

- **autoskipinbox.py**: Main inbox processing script
- **get_tofix_from.py**: Process tofix emails and create keep-inbox filters
- **get_todump_from.py**: Process todump emails and create dump filters
- **get_filters.py**: List all Gmail filters
- **get_label_report.py**: Generate label statistics report
- **run-it.sh**: Wrapper script for running all Python scripts

# References

## Gmail API

### Ruby
- [Google Gmail API Quickstart for Ruby](https://developers.google.com/gmail/api/quickstart/ruby)
- [Ruby Documentation](ruby/README.md#references)

### Python
- [Google Gmail API Quickstart for Python](https://developers.google.com/gmail/api/quickstart/python)
- [Python Documentation](python/README.md#references)
