FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick

RUN mkdir /app
WORKDIR /app

COPY . /app

RUN bundle install
