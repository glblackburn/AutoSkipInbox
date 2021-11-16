SHELL=/bin/bash
.EXPORT_ALL_VARIABLES:
.SHELLFLAGS = -uec -o pipefail

RUBY_VERSION=3.0.2

VPATH=/usr/local/bin:${HOME}/.rbenv/shims:${HOME}/.rbenv/versions/3.0.2/lib/ruby/gems/3.0.0/gems

default: help

.PHONY: install-homebrew
install-homebrew: ## TODO: install homebrew 
	open https://brew.sh/
	$(error complete manual install and retry)
brew:
	make install-homebrew

.PHONY: install-rbenv
install-rbenv: homebrew ## install rbenv to manage ruby
	brew install rbenv
	rbenv install
rbenv:
	make install-rbenv

.PHONY: install-ruby
install-ruby: rbenv ## install ruby version
	rbenv install -s ${RUBY_VERSION}
	rbenv local ${RUBY_VERSION}
	rbenv which ruby
	ruby --version
.ruby-version:
	echo "target: $@"
	make install-ruby
ruby:
	echo "target: $@"
	make install-ruby

install-google-api-client: ## install google-api-client-0.53.0
	gem install google-api-client -v '~> 0.8'
google-api-client-0.53.0:
	make install-google-api-client

setup: brew rbenv .ruby-version ruby google-api-client-0.53.0 ## setup the system to run this application

configure-google-api-auth: ## setup the auth for GMail api
	open https://developers.google.com/gmail/api/quickstart/ruby

run: ## run the AutoSkipInbox
	ruby autoskipinbox.rb

.PHONY: help
help:
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
