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

ENV SLACK_API_TOKEN="xoxb-247325392742-nKWen01aEkIMoyYQts6xvi5p"
ENV RACK_ENV="production"

ENTRYPOINT ./start.sh