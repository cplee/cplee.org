### Credit: https://blog.bramp.net/post/2015/08/01/hugo-makefile/

# All input files
FILES=$(shell find archetypes config.toml content data layouts resources static themes -type f)

# Below are PHONY targets
default: check

deps:
	@brew ls hugo || brew install hugo
	@npm ls htmlhint -g  --depth 1 || npm install htmlhint -g	

help:
	@echo "Usage: make <command>"
	@echo "  default Builds the blog"
	@echo "  clean   Cleans all build files"
	@echo "  watch   Runs hugo in watch mode, waiting for changes"
	@echo ""
	@echo "New article:"
	@echo "  hugo new post/the_title"
	@echo "  $$EDITOR content/post/the_title.md"
	@echo "  make watch"
	@echo "  open "

check: public
	@htmlhint public

clean:
	-rm -rf public

watch: clean
	hugo server -w

deploy: clean check
	aws s3 sync --acl "public-read" --sse "AES256" public/ s3://cplee.org/

clear-cache:
	aws cloudfront create-invalidation --distribution-id E13UEQT4E03VGU --paths "/*"

.PHONY: default help check clean watch deploy clear-cache

# Below are file based targets
public: $(FILES)
	hugo

	# Ensure the public folder has it's mtime updated.
	touch $@
