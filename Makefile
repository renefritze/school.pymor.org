JEKYLL_VERSION=3.8
THIS_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
DOCKER_CMD=docker
JEKYLL_UID=$(shell id -u)
JEKYLL_GID=$(shell id -g)
DOCKER=$(DOCKER_CMD) run $(INTERACTIVE) --rm --label=jekyll --volume $(THIS_DIR):/srv/jekyll \
 		-v $(THIS_DIR)/.cache/bundle:/usr/local/bundle \
		-e JEKYLL_GID=$(JEKYLL_GID) -e JEKYLL_UID=$(JEKYLL_UID) \
	  -p 127.0.0.1:4000:4000 jekyll/builder:${JEKYLL_VERSION}

IGNORE_HREFS=""
CONFIG=_config.yml

build: install
	$(DOCKER) bundle exec jekyll build --trace --config $(CONFIG)

serve: INTERACTIVE=-it
serve: build
	$(DOCKER) bundle exec jekyll serve --config $(CONFIG) --host 0.0.0.0

new:
	$(DOCKER) bundle exec jekyll new /srv/jekyll/site

run: INTERACTIVE=-it
run:
	$(DOCKER) bash

install:
	$(DOCKER) bundle install

gemfile.lock:
	$(DOCKER) bundle update

check: build
	$(DOCKER) bundle exec htmlproofer _site \
		--empty-alt-ignore --allow-hash-href --url-ignore $(IGNORE_HREFS) \
		--internal_domains "school.pymor.org" --file-ignore "/past/" --check-html

clean:
	rm -rf _site .cache .jekyll-cache

.PHONY: new serve build clean
