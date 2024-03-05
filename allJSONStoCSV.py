import sys
import os
import pandas as pd
import json

def read_json_to_table(json_directory, csv_file_path):
    try:
        # Read the existing CSV file into a DataFrame if it exists
        if os.path.exists(csv_file_path):
            df = pd.read_csv(csv_file_path)
        else:
            df = pd.DataFrame()

        # Loop through all JSON files in the specified directory
        for filename in os.listdir(json_directory):
            if filename.endswith(".json"):
                json_file_path = os.path.join(json_directory, filename)

                # Read the new JSON file as a Python object
                with open(json_file_path, 'r') as file:
                    data = json.load(file)

                # Convert the Python object to a DataFrame
                new_data_df = pd.json_normalize(data)

                # Concatenate the new data with the existing DataFrame
                df = pd.concat([df, new_data_df], ignore_index=True)

        # Display the updated DataFrame
        print(df)

        df.to_csv(csv_file_path, index=False)
        print(f"DataFrame appended to {csv_file_path}")

    except Exception as e:
        print(f"Error processing files: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <json_directory> <csv_file_path>")
        sys.exit(1)
    csv_file_path = sys.argv[2]
    json_directory = sys.argv[1]
    read_json_to_table(json_directory, csv_file_path)

