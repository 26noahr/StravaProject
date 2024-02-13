#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <ACCESS_TOKEN> <STARTING_LINE>"
    exit 1
fi

#This script will get segment data for 95 segments in the csv file segments.csv,
# starting at line STARTING_LINE argument
# This is necessary because of API usage limits

# Assign arguments to variables
ACCESS_TOKEN="$1"
START="$2"

csv_file="segments.csv"

mkdir -p "SegmentJSONs"

# Loop through IDs in the "id" column starting from the specified line
tail -n +"$START" "$csv_file" | cut -d',' -f1 | head -n 24 | while IFS= read -r segment_id; do

    # Make the cURL request to get the segment data and save the output to the specified file
    curl -X GET "https://www.strava.com/api/v3/segments/$segment_id" \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      -o "SegmentJSONs/$segment_id.json" \
    && echo "Segment data for ID $segment_id downloaded successfully." \
    || echo "Error downloading segment data for ID $segment_id."

done




