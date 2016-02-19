#!/bin/bash

mkdir -p tmp
touch history.txt

# strip first line to make it a valid JSON file
curl https://ton.twitter.com/starttls/tls.json | sed 's/data\ \=\ //g' > tmp/tls.json
DATE=$(/usr/local/bin/jq ".global.now" tmp/tls.json)

echo "$(date +%Y%m%d%H%M%S) $DATE"

if ! grep -q "$DATE" history.txt; then
  /usr/local/bin/jq ".domains" tmp/tls.json | python -mjson.tool > domains.json
  /usr/local/bin/jq ".global" tmp/tls.json | python -mjson.tool > global.json
  echo "$DATE" >> history.txt
  git add domains.json global.json history.txt
  git commit -m "Update TLS data $DATE"
fi

rm -r tmp/*
