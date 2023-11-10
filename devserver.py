#!/usr/bin/env python3

from livereload import Server, shell

server = Server()
server.watch('docs/**/*', 'mkdocs build --dirty')
server.watch('mkdocs.yml', 'mkdocs build --dirty')
server.watch('resume/*', 'make site/resume/casey-lee-resume.pdf')
server.serve(root='site', debug=True, open_url_delay=0)