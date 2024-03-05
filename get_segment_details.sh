#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <ACCESS_TOKEN> <STARTING_LINE>"
    exit 1
fi

# Assign arguments to variables
ACCESS_TOKEN="$1"
START="$2"
MAX_ITERATIONS=100  # Set the maximum number of iterations

text_file="all_ids.txt"

mkdir -p "SegmentJSONs"

# Initialize the counter
iteration=0

# Loop through lines in the text file starting from the specified line
tail -n +"$START" "$text_file" | while IFS= read -r segment_id; do
    # Check if the maximum number of iterations is reached
    if [ "$iteration" -ge "$MAX_ITERATIONS" ]; then
        echo "Maximum number of iterations reached. Exiting the loop."
        break
    fi

    # Make the cURL request to get the segment data and save the output to the specified file
    curl -X GET "https://www.strava.com/api/v3/segments/$segment_id" \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      -o "SegmentJSONs/$segment_id.json" \
    && echo "Segment data for ID $segment_id downloaded successfully." \
    || echo "Error downloading segment data for ID $segment_id."

    # Increment the counter
    ((iteration++))
done

