import os
import json
import csv

#This script goes through the SegmentJSONs folder, 
# and converts each json to a line in a the data.csv file

def process_json_file(json_file_path):
    with open(json_file_path, 'r') as file:
        data = json.load(file)
        return data

def create_csv(data_list, csv_file_path):
    headers = set(field for row in data_list for field in row.keys())
    with open(csv_file_path, 'w', newline='') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=headers)
        writer.writeheader()
        writer.writerows(data_list)

def main():
    segment_dir = "SegmentJSONs"
    csv_file_path = "data.csv"
    
    data_list = []

    # Traverse the directory
    for filename in os.listdir(segment_dir):
        if filename.endswith(".json"):
            json_file_path = os.path.join(segment_dir, filename)
            data = process_json_file(json_file_path)
            data_list.append(data)

    # Create CSV
    create_csv(data_list, csv_file_path)
    print(f"CSV file '{csv_file_path}' created successfully.")

if __name__ == "__main__":
    main()

