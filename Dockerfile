FROM ruby:2.3-alpine

RUN \
  apk --update add \
    build-base \
    # libressl-dev \
    libxml2-dev \
    libxslt-dev \
    mysql-client \
    postgresql \
    readline-dev \
    redis \
    sqlite \
    tar \
    zlib-dev && \
  rm -rf /var/cache/apk/*

RUN gem install backup clockwork --no-ri --no-rdoc

ADD config.rb /root/Backup/config.rb
ADD model.rb /root/Backup/models/

WORKDIR /app
ADD . /app

VOLUME ["/home/backups", "/etc/backups", "/var/lib/backups", "/var/log/backups"]

CMD clockwork clock.rb
