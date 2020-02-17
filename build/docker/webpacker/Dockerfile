FROM ruby:2.7.0-alpine

RUN apk add --update build-base libxml2-dev tzdata nodejs yarn && \
      gem update bundler

WORKDIR /app
ADD gems.rb gems.locked package.json yarn.lock /app/
RUN bundle install && yarn install
