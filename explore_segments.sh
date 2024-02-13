#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <ACCESS_TOKEN> <OUTPUT_FILE> <BOUNDS>"
    exit 1
fi

# Assign arguments to variables
ACCESS_TOKEN="$1"
OUTPUT_FILE="$2"
BOUNDS="$3"
ACTIVITY_TYPE="$4"
#MIN_CAT="$5"
#MAX_CAT="$6"

# Make the cURL request to explore segments and save the output to the specified file
curl -X GET "https://www.strava.com/api/v3/segments/explore?bounds=$BOUNDS&activity_type=riding" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -o "$OUTPUT_FILE"
