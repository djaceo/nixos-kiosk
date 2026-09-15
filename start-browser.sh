#!/usr/bin/env bash

export LANG=de_DE.UTF-8
export LANGUAGE=de_DE:de

while true; do
  chromium \
    --kiosk \
    --incognito \
    --start-fullscreen \
    --lang=de-DE \
    --no-first-run \
    --no-default-browser-check \
    https://www.google.de

  sleep 1
done