FROM ruby:3.0.0
RUN apt-get update && apt-get install -y curl build-essential gnupg postgresql-11 libpq-dev
RUN gem install bundler --no-document -v '2.3.9'
WORKDIR /app
COPY . /app
RUN bundle check || bundle install
