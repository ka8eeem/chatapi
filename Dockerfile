FROM ruby:2.6.10-alpine

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      openssl \
      pkgconfig \
      tzdata \
      mariadb-dev


WORKDIR /app
COPY Gemfile Gemfile.lock ./

RUN gem install nokogiri
RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install

COPY . ./

EXPOSE 3000
