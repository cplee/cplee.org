FROM ruby:2.7.8-buster

RUN apt-get update && apt-get install -y libssl-dev && apt-get clean
RUN gem install json_resume -v 1.0.6

# Force older version of wkhtmltopdf
RUN gem install wkhtmltopdf-binary -v 0.12.5.4
RUN gem uninstall wkhtmltopdf-binary -v '>=0.12.6'

ENV RUBYOPT="-KU -E utf-8:utf-8"
