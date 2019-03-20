# Getting Started

## Overview

TODO

## Install

The installer will do the following:
* detech ruby in your path
* check the version
* install the needed gems
* add "run-it.sh" to your crontab.

### Prerequisites

For MacOS, install an updated version of ruby.  Personally, I use
Homebrew to install Ruby.

Homebrew: https://brew.sh/

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Ruby: https://www.ruby-lang.org/en/documentation/installation/#homebrew

    brew install ruby

### install.sh
To install run the "install.sh" script.

    install.sh

### run-it.sh

run-it.sh does not depended on the PATH variable, because this script
is run from cron.  The RUBY_PATH variable needs to be updated to the
install location for the version of ruby you are using.

Homebrew as of 3/19/2019, no longer symlinks ruby into /usr/local/bin.  The new path to ruby is '/usr/local/opt/ruby/bin'.

From the Homebrew install for ruby.

    If you need to have ruby first in your PATH run:
      echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.bash_profile

# TODO
* figure out how to do google auth as part of install.  there is a step past saving the client_secret.json file that prompts as part of the auth.
* add overview
* document how to used once installed
* update installer to validate ruby version
* DONE: document shell and ruby scripts
* DONE: update installer to install ruby gems

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
