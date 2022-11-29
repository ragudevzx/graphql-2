FROM ruby:2.6.3

RUN apt-get update -qq

WORKDIR /app
COPY Gemfile /app/Gemfile

RUN gem install bundler -v '2.1.4'

RUN bundle install
COPY . /app

EXPOSE 3001