FROM ruby:2.1

COPY . /srv/github-commit-watcher
WORKDIR /srv/github-commit-watcher

RUN bundle install