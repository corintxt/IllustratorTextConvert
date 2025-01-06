#!/bin/bash

CONFIG=$(cat "$(dirname "$0")/config.json")
API_KEY=$(echo "$CONFIG" | grep -o '"apiKey": *"[^"]*"' | cut -d'"' -f4)

INPUT_FILE="/Users/cfaife/Documents/MATERIALS/Code/Illustrator/IllustratorTextConvert/translate.txt"
OUTPUT_FILE="$(dirname "$INPUT_FILE")/translation.txt"
TEXT=$(cat "$INPUT_FILE")
TARGET_LANGUAGE="French"

escape_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//\//\\/}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    echo "$s"
}

ESCAPED_TEXT=$(escape_json "$TEXT")

JSON_PAYLOAD='{
    "model": "claude-3-sonnet-20240229",
    "system": "You are a helpful translator. Translate the following text into '"$TARGET_LANGUAGE"'. Preserve all line breaks and formatting.",
    "messages": [
        {
            "role": "user",
            "content": "'"$ESCAPED_TEXT"'"
        }
    ],
    "max_tokens": 4096
}'

response=$(curl -s -X POST "https://api.anthropic.com/v1/messages" \
    -H "x-api-key: $API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "$JSON_PAYLOAD")

if [[ "$response" == *"error"* ]]; then
    echo "Error: API request failed"
    echo "API Response: $response"
    exit 1
else
    # Extract text and convert escaped newlines to actual newlines
    echo "$response" | grep -o '"text":"[^"]*"' | sed 's/"text":"\(.*\)"/\1/' | sed 's/\\n/\n/g' > "$OUTPUT_FILE"
    echo "Translation saved to: $OUTPUT_FILE"
fi