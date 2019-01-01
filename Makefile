# Configuration 
BUCKET_NAME ?= cplee.org
DISTRIBUTION_ID ?= E13UEQT4E03VGU 
AWS_IMAGE ?= cibuilds/aws:1.16.81
HUGO_IMAGE ?= cibuilds/hugo:0.53
JSONRESUME_IMAGE ?= json_resume:1.0.6


### Evaluate docker commands
DOCKER      := docker run --rm -v $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))):/workspace -w /workspace 
AWS         := $(DOCKER) -v $(HOME)/.aws:/root/.aws -e AWS_PROFILE -e AWS_REGION $(AWS_IMAGE) aws
HUGO        := $(DOCKER) -p 1313:1313 $(HUGO_IMAGE) hugo
JSONRESUME  := $(DOCKER) -t $(JSONRESUME_IMAGE) json_resume
HTMLPROOFER := $(DOCKER) $(HUGO_IMAGE) htmlproofer

build: clean resume
	$(HUGO)
	$(HTMLPROOFER) public --empty-alt-ignore --disable-external

resume: 
	docker build -t $(JSONRESUME_IMAGE) resume/
	$(JSONRESUME) convert --template=resume/custom_html.mustache --out=html --dest_dir=static resume/resume.yml
	$(JSONRESUME) convert --template=resume/custom_html.mustache --out=pdf --dest_dir=static/resume resume/resume.yml

watch: clean resume
	sleep 2 && open http://127.0.0.1:1313/ &
	$(HUGO) server -w --bind 0.0.0.0

help:
	@echo "Usage: make <command>"
	@echo "  build        Build and check the site"
	@echo "  watch        Runs hugo in watch mode, waiting for changes"
	@echo "  deploy       Deploy to S3 bucket $(BUCKET_NAME)"
	@echo "  clear-cache  Invalidate CloudFront distribution $(DISTRIBUTION_ID)"
	@echo "  clean        Cleans all build files"
	@echo ""
	@echo "New article:"
	@echo "  hugo new post/the_title"
	@echo "  $$EDITOR content/post/the_title.md"
	@echo "  make watch"
	@echo "  open "

deploy: build
	$(AWS) s3 sync --acl "public-read" --sse "AES256" public/ s3://$(BUCKET_NAME)/

clear-cache:
	$(AWS) cloudfront create-invalidation --distribution-id $(DISTRIBUTION_ID) --paths "/*"

clean:
	-rm -rf public
	-rm -rf static/resume

.PHONY: help build watch deploy clear-cache clean resume
