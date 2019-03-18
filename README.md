# Getting Started

## Overview

TODO

## Install

To install the script run "install.sh"

Currently, the installer does a non-destructive add to your crontab.

# TODO
* add overview
* update installer to install ruby gems
* document how to used once installed
* update installer to validate ruby version
* DONE: document shell and ruby scripts

# Scripts
## install.sh

install.sh will setup the needed libraries for the AutoSkipInbox and
install a crontab to run every 15 minutes.

* checking compatability:
  https://stackoverflow.com/questions/44961182/ruby-upgrade-version-and-code-compatibility-checker

## run-it.sh

run-it.sh is the wrapper script that is setup in cron.  This script
calls autoskipinbox.rb and get-tofix-from.rb.  The script also
captures the output from the ruby scripts into a datetime stamped run
log.  The run log is then processes for summary statictics that are
saved in the autoskipinbox.log.

## autoskipinbox.rb

autoskipinbox.rb will process email in the Inbox.  Any email that is
not marked as "keep-inbox" or "autoskipinbox/tofix" will be archived
and the "autoskipinbox" will be applied.

## get-tofix-from.rb

get-tofix-from.rb will process any email with the label
"autoskipinbox/tofix".  For each matching message, a filter will be
created to match incoming email with the from address and apply the
"keep-inbox" label.

* TODO: update to apply "keep-inbox" and "Inbox" labels.  Currently,
  this is a manual step.


# References

# Ruby Setup

## gem install permission issue 
On macOS Mojave with the default ruby install the below error will display when running "gem install google-api-client -v '~> 0.8'"

    ERROR:  While executing gem ... (Gem::FilePermissionError)
        You don't have write permissions for the /Library/Ruby/Gems/2.3.0 directory.

https://stackoverflow.com/questions/14607193/installing-gem-or-updating-rubygems-fails-with-permissions-error

# GMail API
## Google GMail API for Ruby
https://developers.google.com/gmail/api/quickstart/ruby

## Install the Google Client Library
gem install google-api-client -v '~> 0.8'

Run example
ruby quickstart.rb

NOTE: remove token.yaml when there is an authentiation error.  could
be a time timeout issue

## Rubydoc
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#list_user_messages-instance_method
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#get_user_message-instance_method
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/ListMessagesResponse#messages-instance_method
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/Message

## Example
https://gist.github.com/jkotchoff/34fba5c6df03a5caadad286b80c97b96#file-emailed_zip_file_extractor-rb-L81
