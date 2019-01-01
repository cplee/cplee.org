FROM ruby:2.6.0-stretch

RUN apt-get update && apt-get install -y libssl1.0-dev && apt-get clean
RUN gem install json_resume -v 1.0.6

ENV RUBYOPT="-KU -E utf-8:utf-8"