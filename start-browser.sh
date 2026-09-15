#!/usr/bin/env bash

while true; do
  chromium \
    --kiosk \
    --incognito \
    --start-fullscreen \
    https://www.google.de

  sleep 1
done