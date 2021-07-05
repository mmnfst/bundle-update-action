FROM ruby:2.7.2-alpine

COPY . /app
WORKDIR /app
RUN apk add --no-cache bash
RUN /bin/sh
RUN apk update && apk add --virtual build-dependencies build-base
RUN gem install bundler
RUN bundle install
ENTRYPOINT ["ruby", "/app/action.rb"]
