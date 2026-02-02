#!/usr/bin/env bash

# Define a function to extract RSS feed URL using curl and sed
extract_rss_url() {
    youtube_channel_url="$1"
    rss_url=$(curl -s "$youtube_channel_url" | sed -n 's/.*title="RSS"\s\+href="\([^"]\+\).*/\1/p')
    echo "$rss_url"
}

# Add YouTube channel URLs to this array
youtube_channel_urls=(
    "https://www.youtube.com/@jvscholz"
    "https://www.youtube.com/@yerbamatelab/videos"
)

# Loop through the array and extract RSS feed URLs
for url in "${youtube_channel_urls[@]}"; do
    rss_feed_url=$(extract_rss_url "$url")
    if [ -n "$rss_feed_url" ]; then
        echo "Channel: $url"
        echo "RSS Feed: $rss_feed_url"
    else
        echo "No RSS feed found for $url"
    fi
done
