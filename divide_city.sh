#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <ACCESS_TOKEN> <CENTER_LAT> <CENTER_LNG> <NUM_DIVISIONS>"
    exit 1
fi

# Assign arguments to variables
ACCESS_TOKEN="$1"
CENTER_LAT="$2"
CENTER_LNG="$3"
NUM_DIVISIONS="$4"

DIR_NAME="raw_${CENTER_LAT}_${CENTER_LNG}"

# Create the directory if it doesn't exist
mkdir -p "$DIR_NAME"

# n divisions in each direction makes n*n sub-regions

# Approximate 10 miles in degrees
delta_degrees="1/7"

# Latitude Box
NORTH=$(echo "scale=8; $CENTER_LAT + $delta_degrees" | bc)
SOUTH=$(echo "scale=8; $CENTER_LAT - $delta_degrees" | bc)

# Longitude Box
WEST=$(echo "scale=8; $CENTER_LNG - $delta_degrees" | bc)
EAST=$(echo "scale=8; $CENTER_LNG + $delta_degrees" | bc)

#echo "$NORTH $SOUTH $EAST $WEST"

# Use double parentheses for arithmetic operations, pipe decimal numbers through basic calculator
DISTANCE_Y=$(echo "scale=8; ($NORTH - $SOUTH) / $NUM_DIVISIONS" | bc )
DISTANCE_X=$(echo "scale=8; ($EAST - $WEST) / $NUM_DIVISIONS" | bc )
#echo "$DISTANCE_Y $DISTANCE_X"

for ((i = 0; i < $NUM_DIVISIONS; i++)); do

    LOW_Y=$(echo "$SOUTH + $DISTANCE_Y * $i" | bc)
    HIGH_Y=$(echo "$SOUTH + $DISTANCE_Y * ($i + 1)" | bc)

    for ((j = 0; j < $NUM_DIVISIONS; j++)); do

        LOW_X=$(echo "$WEST + $DISTANCE_X * $j" | bc)
        HIGH_X=$(echo "$WEST + $DISTANCE_X * ($j + 1)" | bc)

        BOUNDS="$LOW_Y,$LOW_X,$HIGH_Y,$HIGH_X"
        echo "$BOUNDS"

        ./explore_segments.sh "$ACCESS_TOKEN" "${DIR_NAME}/seg_${LOW_Y}_${HIGH_Y}_${LOW_X}_${HIGH_X}.json" "$BOUNDS"
    done
done
