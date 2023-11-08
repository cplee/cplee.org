.PHONY: all
all: public/resume/resume.pdf

.PHONY: watch
watch:
	watch make all --silent

public/resume:
	mkdir -p public/resume

public/resume/style.css: resume/style.css public/resume
	cp $< $@

public/resume/resume.html: resume/resume.md public/resume/style.css public/resume
	pandoc --standalone \
	--css=style.css \
	--from markdown+emoji+markdown_in_html_blocks --to html \
	--metadata pagetitle='Resume - Casey Lee' \
	--output $@ $<

public/resume/resume.pdf: public/resume/resume.html
	weasyprint \
	$< $@

.PHONY: clean
clean:
	rm -rf public