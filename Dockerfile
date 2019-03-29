FROM ruby:2.6.1-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY . /app
WORKDIR /app

# installing *dev stuff
RUN apk add --update ruby-dev ruby-io-console ruby-json yaml build-base &&\
    bundle install --without development test --deployment --force &&\
    apk del ruby-dev build-base &&\
    rm -rf /var/cache/apk/*

RUN chown -R appuser:appgroup /app
USER appuser

ENTRYPOINT ./start.sh