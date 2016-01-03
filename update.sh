#!/bin/bash

mkdir -p tmp
touch history.txt

# strip first and last line to make it a valid JSON file
curl https://ton.twitter.com/starttls/tls.json | tail -n +2 | head -n -1 > tmp/tls.json
DATE=$(jq ".global.now" tmp/tls.json)

if ! grep -q "$DATE" history.txt; then
  jq ".domains" tmp/tls.json | python -mjson.tool > domains.json
  jq ".global" tmp/tls.json | python -mjson.tool > global.json
  #jq ".domains" tls.json | jq -r "to_entries[] | .key | @text" | sort > domains.txt
  echo "$DATE" >> history.txt
  git add domains.json global.json history.txt
  git commit -m "Update TLS data $DATE"
fi

rm -r tmp/*
