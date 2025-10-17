SHELL=/bin/bash
.EXPORT_ALL_VARIABLES:
.SHELLFLAGS = -uec -o pipefail

default: help

#TODO
install-homebrew: ## TODO: install homebrew 

# need to update to check if rbenv already installedk.
install-rbenv: ## install rbenv to manage ruby
	brew install rbenv
	rbenv install

setup: ## setup the system to run this application
	make install-rbenv
	gem install google-api-client -v '~> 0.8'

run: ## run the AutoSkipInbox
	ruby autoskipinbox.rb

.PHONY: help
help:
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
