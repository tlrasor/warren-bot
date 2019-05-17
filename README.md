Warren-bot
-----------

[![Build Status](https://travis-ci.org/tlrasor/warren-bot.svg?branch=master)](https://travis-ci.org/tlrasor/warren-bot)


# deploy using docker stack
```
docker service create \
    --name warren-bot \
    --update-delay 5s \
    --env RACK_ENV=production \
    --env SLACK_API_TOKEN="YOUR_KEY" \
    --publish 18888:8888 \
    warren-bot:arm
```