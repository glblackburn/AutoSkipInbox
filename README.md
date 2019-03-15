# Getting Started
To install the script run "install.sh"

Currently, the installer does a non-destructive add to your crontab.

# TODO
* document how to used once installed
* update installer to validate ruby version
* update installer to install ruby gems
* document shell and ruby scripts

# References

Google GMail API for Ruby
https://developers.google.com/gmail/api/quickstart/ruby

Install the Google Client Library
gem install google-api-client -v '~> 0.8'

Run example
ruby quickstart.rb

NOTE: remove token.yaml when there is an authentiation error.  could be a time timeout issue

Rubydoc
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#list_user_messages-instance_method
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/ListMessagesResponse#messages-instance_method
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/Message
https://gist.github.com/jkotchoff/34fba5c6df03a5caadad286b80c97b96#file-emailed_zip_file_extractor-rb-L81

https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#get_user_message-instance_method