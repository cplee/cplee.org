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

site/resume/%.ttf: resume/%.ttf
	cp $< $@

site/resume/%.css: resume/%.css
	cp $< $@

site/resume/%.html: resume/%.md 
	pandoc --standalone \
	--css=style.css \
	--from markdown+emoji+markdown_in_html_blocks --to html \
	--metadata pagetitle='Resume - Casey Lee' \
	--output $@ $<

site/resume/casey-lee-resume.pdf: site/resume site/resume/resume.html site/resume/style.css site/resume/fa-brands-400.ttf site/resume/fa-solid-900.ttf
	weasyprint site/resume/resume.html site/resume/casey-lee-resume.pdf

.PHONY: clean
clean:
	rm -rf site