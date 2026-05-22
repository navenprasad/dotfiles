#!/bin/bash

# 1. Get OAuth Token (Requires gcloud CLI installed)
TOKEN=$(gcloud auth print-access-token 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo "Error: Could not get OAuth token."
    echo "Please run 'gcloud auth application-default login' and try again."
    exit 1
fi

# 2. Make a minimal request to get the headers
# Using gemini-1.5-flash as it has the most visible headers
echo "Checking Gemini API Quota Status..."
RESPONSE=$(curl -s -i -X POST \
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "contents": [{"parts": [{"text": "ping"}]}],
        "generationConfig": {"max_output_tokens": 1}
    }')

# 3. Parse and display the rate limit headers
echo "--------------------------------------"
echo "$RESPONSE" | grep -i "x-ratelimit-remaining-requests" | sed 's/x-ratelimit-remaining-requests:/Remaining Requests:/i'
echo "$RESPONSE" | grep -i "x-ratelimit-limit-requests" | sed 's/x-ratelimit-limit-requests:/Total Limit (Requests):/i'
echo "$RESPONSE" | grep -i "x-ratelimit-remaining-tokens" | sed 's/x-ratelimit-remaining-tokens:/Remaining Tokens:/i'
echo "$RESPONSE" | grep -i "x-ratelimit-reset-requests" | sed 's/x-ratelimit-reset-requests:/Resets In:/i'
echo "--------------------------------------"

# Check if no headers were returned
if [[ ! "$RESPONSE" =~ "x-ratelimit" ]]; then
    echo "No rate-limit headers found in the response."
    echo "This often happens if you are on a paid/unlimited tier where headers are hidden."
fi
