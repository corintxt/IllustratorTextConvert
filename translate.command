#!/bin/bash
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "~~~~~~~TRANSLATE.TEXT~~~~~~~~~"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

CONFIG=$(cat "$(dirname "$0")/config.json")
API_KEY=$(echo "$CONFIG" | grep -o '"apiKey": *"[^"]*"' | cut -d'"' -f4)

INPUT_FILE="/tmp/translate_input.txt"
ARG_FILE="/tmp/translate_args.txt"
OUTPUT_FILE="$(dirname "$INPUT_FILE")/translation.txt"
TEXT=$(cat "$INPUT_FILE")

echo "Found text to translate."

escape_json() {
    local s="$1"
    s="${s//$'\n'/ }"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//\//\\/}"
    s="${s//$'\r'/ }"
    s="${s//$'\t'/ }"
    echo "$s"
}

ESCAPED_TEXT=$(escape_json "$TEXT")
# First line of text from input text file defines target language
TARGET_LANGUAGE=$(echo "$ESCAPED_TEXT" | head -n 1)

JSON_PAYLOAD='{
    "model": "claude-3-sonnet-20240229",
    "system": "You are a translator. Be direct and concise. Translate the following text into '"$TARGET_LANGUAGE"', keeping the markers starting [----- and [=== in the same positions above and below translated text.",
    "messages": [
        {
            "role": "user",
            "content": "'"$ESCAPED_TEXT"'"
        }
    ],
    "max_tokens": 4096
}'

echo "Sending text to API for translation..."

response=$(curl -s -X POST "https://api.anthropic.com/v1/messages" \
    -H "x-api-key: $API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "$JSON_PAYLOAD")

if [[ "$response" == *"error"* ]]; then
    echo "Error: API request failed"
    echo "API Response: $response"
    exit 1
else # Process text response and save to file
    echo "Response received."
    echo "$response" | grep -o '"text":"[^"]*"' | sed 's/"text":"\(.*\)"/\1/' | sed 's/\\n//g' | \
    sed -e 's/\[----- /\n[----- /g' \
        -e 's/\[=== /\n[=== /g' \
        -e 's/] /]\n/g' > "$OUTPUT_FILE"
    echo "Translation saved to: $OUTPUT_FILE"
fi
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Ready to import translation!"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"