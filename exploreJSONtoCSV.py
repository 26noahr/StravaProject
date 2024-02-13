#This script goes though json files outputed from strava api segment explorer, and adds
#them to segments.csv
#The directory it searches through is hard-coded right now

import json
import csv
import os

# Output CSV file
csv_file = "segments.csv"

# Header line for CSV
header = ["id", "name", "climb_category", "climb_category_desc", "avg_grade", 
          "start_lat", "start_lng", "end_lat", "end_lng", "elev_difference", 
          "distance", "points"]

# Write header to CSV file
with open(csv_file, 'w', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(header)

# Loop through each JSON file in the specified subdirectory
for file_name in os.listdir("raw_47.7_-116.8"):
    if file_name.endswith(".json"):
        file_path = os.path.join("raw_47.7_-116.8", file_name)
        with open(file_path, 'r') as json_file:
            try:
                data = json.load(json_file)
                segments = data.get("segments", [])

                # Append segment data to CSV file
                with open(csv_file, 'a', newline='') as csvfile:
                    csv_writer = csv.writer(csvfile)
                    for segment in segments:
                        csv_writer.writerow([
                            segment.get("id", ""),
                            segment.get("name", ""),
                            segment.get("climb_category", ""),
                            segment.get("climb_category_desc", ""),
                            segment.get("avg_grade", ""),
                            segment.get("start_latlng", [])[0],
                            segment.get("start_latlng", [])[1],
                            segment.get("end_latlng", [])[0],
                            segment.get("end_latlng", [])[1],
                            segment.get("elev_difference", ""),
                            segment.get("distance", ""),
                            segment.get("points", "")
                        ])
                print(f"Segments from {file_path} added to CSV.")
            except json.JSONDecodeError:
                print(f"Skipping {file_path}. Invalid JSON format.")
                continue

print(f"CSV file '{csv_file}' created successfully.")
