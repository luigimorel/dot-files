#!/usr/bin/env bash

HOSTS_FILE="/etc/hosts"

SITES=(
"facebook.com"
"www.facebook.com"
"m.facebook.com"
"instagram.com"
"www.instagram.com"
"twitter.com"
"www.twitter.com"
"x.com"
"www.x.com"
"tiktok.com"
"www.tiktok.com"
"reddit.com"
"www.reddit.com"
"snapchat.com"
"www.snapchat.com"
"pinterest.com"
"www.pinterest.com"
"linkedin.com"
"www.linkedin.com"
"youtube.com"
)

echo "Blocking social media sites..."

for site in "${SITES[@]}"; do
    if ! grep -q "$site" "$HOSTS_FILE"; then
        echo "127.0.0.1 $site" | sudo tee -a "$HOSTS_FILE" > /dev/null
    fi
done

echo "Done. Social media domains added to $HOSTS_FILE"
