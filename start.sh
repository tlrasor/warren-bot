#!/usr/bin/env sh

if [ -z "$RACK_ENV" ]; then
    export RACK_ENV="development"
    echo setting RACK_ENV to development
fi
if [ -z "$RACK_PORT" ]; then
    export RACK_PORT="8888"
    echo "setting RACK_PORT to 8888"
fi

bundle exec rackup --env "$RACK_ENV" --port "$RACK_PORT" $@