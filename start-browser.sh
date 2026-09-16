#!/usr/bin/env bash

export LANG=de_DE.UTF-8
export LANGUAGE=de_DE:de

while true; do
  chromium \
    --kiosk \
    --app=https://www.google.de \
    --incognito \
    --start-fullscreen \
    --lang=de-DE \
    --no-first-run \
    --no-default-browser-check

  sleep 1
done