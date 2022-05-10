# -*- coding: utf-8 -*-
# SOURCE: https://github.com/autopilotpattern/jenkins/blob/master/makefile
MAKEFLAGS += --warn-undefined-variables
# .SHELLFLAGS := -eu -o pipefail

# SOURCE: https://github.com/luismayta/zsh-servers-functions/blob/b68f34e486d6c4a465703472e499b1c39fe4a26c/Makefile
# Configuration.
SHELL = /bin/bash
ROOT_DIR = $(shell pwd)
PROJECT_BIN_DIR = $(ROOT_DIR)/bin
DATA_DIR = $(ROOT_DIR)/var
SCRIPT_DIR = $(ROOT_DIR)/script

WGET = wget
# SOURCE: https://github.com/wk8838299/bullcoin/blob/8182e2f19c1f93c9578a2b66de6a9cce0506d1a7/LMN/src/makefile.osx
HAVE_BREW=$(shell brew --prefix >/dev/null 2>&1; echo $$? )


.PHONY: list help default all check fail-when-git-dirty
.PHONY: pre-commit-install check-connection-postgres monkeytype-stub monkeytype-apply monkeytype-ci

.PHONY: FORCE_MAKE

PR_SHA                := $(shell git rev-parse HEAD)

define ASCILOGO
vuls-docker-compose
=======================================
endef

export ASCILOGO

# http://misc.flogisoft.com/bash/tip_colors_and_formatting

RED=\033[0;31m
GREEN=\033[0;32m
ORNG=\033[38;5;214m
BLUE=\033[38;5;81m
NC=\033[0m

export RED
export GREEN
export NC
export ORNG
export BLUE

# verify that certain variables have been defined off the bat
check_defined = \
		$(foreach 1,$1,$(__check_defined))
__check_defined = \
		$(if $(value $1),, \
			$(error Undefined $1$(if $(value 2), ($(strip $2)))))

export PATH := ./script:./bin:./bash:./venv/bin:$(PATH)

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_FOLDER := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
CURRENT_DIR := $(shell pwd)
MAKE := make
PY_MODULE_NAME := prometheus-docker-compose

list_allowed_args := product ip command role tier cluster non_root_user host

default: all

all: help

.PHONY: help
help: ## ** Show this help message
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


pull:
	docker pull vuls/go-cve-dictionary
	docker pull vuls/goval-dictionary
	docker pull vuls/gost
	docker pull vuls/go-exploitdb
	docker pull vuls/go-msfdb
	docker pull vuls/go-kev
	docker pull vuls/vuls
	
version: pull
	docker run  --rm  vuls/go-cve-dictionary version
	docker run  --rm  vuls/goval-dictionary version
	docker run  --rm  vuls/gost version
	docker run  --rm  vuls/go-exploitdb version
	docker run  --rm  vuls/go-msfdb version
	docker run  --rm  vuls/go-kev version
	docker run  --rm  vuls/vuls -v

fetch:
# dictonary
	docker run --rm -it \
	-v $(PWD):/go-cve-dictionary \
	-v $(PWD)/go-cve-dictionary-log:/var/log/go-cve-dictionary \
	vuls/go-cve-dictionary fetch nvd
# goval
	docker run --rm -it \
	-v $(PWD):/goval-dictionary \
	-v $(PWD)/goval-dictionary-log:/var/log/goval-dictionary \
	vuls/goval-dictionary fetch redhat 5 6 7 8
	
	docker run --rm -it \
	-v $(PWD):/goval-dictionary \
	-v $(PWD)/goval-dictionary-log:/var/log/goval-dictionary \
	vuls/goval-dictionary fetch debian 7 8 9 10 11
	
	docker run --rm -it \
	-v $(PWD):/goval-dictionary \
	-v $(PWD)/goval-dictionary-log:/var/log/goval-dictionary \
	vuls/goval-dictionary fetch ubuntu 14 16 18 19 20 21 22
# gost
	docker run --rm -i \
	-v $(PWD):/gost \
	-v $(PWD)/gost-log:/var/log/gost \
	vuls/gost fetch redhat
	
	docker run --rm -i \
	-v $(PWD):/gost \
	-v $(PWD)/gost-log:/var/log/gost \
	vuls/gost fetch debian
	
	docker run --rm -i \
	-v $(PWD):/gost \
	-v $(PWD)/gost-log:/var/log/gost \
	vuls/gost fetch ubuntu
	
# exploitdb
	docker run --rm -i \
	-v $(PWD):/go-exploitdb \
	-v $(PWD)/go-exploitdb-log:/var/log/go-exploitdb \
	vuls/go-exploitdb fetch exploitdb
	
	docker run --rm -i \
	-v $(PWD):/go-exploitdb \
	-v $(PWD)/go-exploitdb-log:/var/log/go-exploitdb \
	vuls/go-exploitdb fetch awesomepoc
	
	docker run --rm -i \
	-v $(PWD):/go-exploitdb \
	-v $(PWD)/go-exploitdb-log:/var/log/go-exploitdb \
	vuls/go-exploitdb fetch githubrepos
	
	docker run --rm -i \
	-v $(PWD):/go-exploitdb \
	-v $(PWD)/go-exploitdb-log:/var/log/go-exploitdb \
	vuls/go-exploitdb fetch inthewild
	
	docker run --rm -i \
	-v $(PWD):/go-msfdb \
	-v $(PWD)/go-msfdb-log:/var/log/go-msfdb \
	vuls/go-msfdb fetch msfdb
	
	docker run --rm -i \
	-v $(PWD):/go-kev \
	-v $(PWD)/go-kev-log:/var/log/go-kev \
	vuls/go-kev fetch kevuln
	
configtest:
# path to config.toml in docker
	docker run --rm -it \
	-v ~/.ssh:/root/.ssh:ro \
	-v $(PWD):/vuls \
	-v $(PWD)/vuls-log:/var/log/vuls \
	vuls/vuls configtest \
	--config=./config.toml 
	
scan:
# path to config.toml in docker
	docker run --rm -it \
	-v ~/.ssh:/root/.ssh:ro \
	-v $(PWD):/vuls \
	-v $(PWD)/vuls-log:/var/log/vuls \
	-v /etc/localtime:/etc/localtime:ro \
	-v /etc/timezone:/etc/timezone:ro \
	vuls/vuls scan \
	-config=./config.toml

local-scan:
	vuls scan -config=./config.toml -results-dir=./vuls-results -log-dir=./vuls-log -vvv

report:
# path to config.toml in docker
	docker run --rm -it \
	-v ~/.ssh:/root/.ssh:ro \
	-v $(PWD):/vuls \
	-v $(PWD)/vuls-log:/var/log/vuls \
	-v /etc/localtime:/etc/localtime:ro \
	vuls/vuls report \
	-format-list \
	-config=./config.toml 

tui:
# path to config.toml in docker
	docker run --rm -it \
	-v ~/.ssh:/root/.ssh:ro \
	-v $(PWD):/vuls \
	-v $(PWD)/vuls-log:/var/log/vuls \
	-v /etc/localtime:/etc/localtime:ro \
	vuls/vuls tui \
	-config=./config.toml 
	
config:
	cp -av example-config.toml config.toml
	
.PHONY: up
up:
	docker-compose -f docker-compose.yml up -d

.PHONY: down
down:
	docker-compose -f docker-compose.yml down

.PHONY: logs
logs:
	docker-compose -f docker-compose.yml logs -f

.PHONY: restart
restart: down up

.PHONY: restart-logs
restart-logs: down up logs