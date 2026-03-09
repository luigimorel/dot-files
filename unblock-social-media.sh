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
"www.youtube.com"
)

echo "Unblocking social media sites..."

for site in "${SITES[@]}"; do
    sudo sed -i "/127.0.0.1 $site/d" "$HOSTS_FILE"
done

echo "Done. Social media domains removed from $HOSTS_FILE"
