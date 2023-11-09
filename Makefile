.PHONY: all
all: lint site resume

.PHONY: resume
resume: site/resume/resume.pdf

.PHONY: lint
lint:
	npx markdownlint docs resume

.PHONY: watch
watch:
	mkdocs serve

.PHONY: watch-resume
watch-resume:
	watch make resume --silent

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

site/resume/resume.pdf: site/resume/resume.html
	weasyprint \
	$< $@

.PHONY: clean
clean:
	rm -rf site