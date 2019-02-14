THIS_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

DOCKER=docker run --rm --label=jekyll --volume $(THIS_DIR):/srv/jekyll \
	  -it -p 127.0.0.1:4000:4000 jekyll/builder:stable

build:
	$(DOCKER) jekyll build

serve: build
	$(DOCKER) jekyll serve

new:
	$(DOCKER) jekyll new /srv/jekyll/site

.PHONY: new serve build
