FROM ruby:3.3-alpine
RUN apk update && apk add make gcc musl-dev tzdata git build-base postgresql-dev
COPY Gemfile* /app/
WORKDIR /app
RUN bundle install
COPY . /app/
CMD ["bin/rails", "s", "-b", "0.0.0.0"]