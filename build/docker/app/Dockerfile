FROM ruby:2.7.0-alpine

RUN apk add --update build-base tzdata && gem update bundler

WORKDIR /app
ADD gems.rb gems.locked /app/
RUN bundle install
