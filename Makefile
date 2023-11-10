.PHONY: all
all: lint site resume

.PHONY: resume
resume: site/resume/casey-lee-resume.pdf

.PHONY: lint
lint:
	markdownlint docs resume

.PHONY: watch
watch: clean site resume
	./devserver.py

site:
	mkdocs build

site/resume: site
	mkdir -p site/resume

site/resume/style.css: resume/style.css site/resume
	cp $< $@

site/resume/resume.html: resume/resume.md site/resume/style.css site/resume
	pandoc --standalone \
	--css=style.css \
	--from markdown+emoji+markdown_in_html_blocks --to html \
	--metadata pagetitle='Resume - Casey Lee' \
	--output $@ $<

site/resume/casey-lee-resume.pdf: site/resume/resume.html
	weasyprint \
	$< $@

.PHONY: clean
clean:
	rm -rf site