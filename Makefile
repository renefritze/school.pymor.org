THIS_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
DOCKER_CMD=docker
DOCKER=$(DOCKER_CMD) run $(INTERACTIVE) --rm --label=jekyll --volume $(THIS_DIR):/srv/jekyll \
 		-v $(THIS_DIR)/.cache:/usr/local/bundle \
	  -p 127.0.0.1:4000:4000 jekyll/builder:stable

IGNORE_HREFS=""

build: install
	$(DOCKER) bundle exec jekyll build

serve: INTERACTIVE=-it
serve: build
	$(DOCKER) bundle exec jekyll serve --host 0.0.0.0 --livereload

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

.PHONY: new serve build
