import os
import re
import sys
import numpy as np

def extract_integers_from_json(folder_path):
    integer_values = []

    # Walk through the directory
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".json"):
                file_path = os.path.join(root, file)

                # Open the JSON file as a text file
                with open(file_path, 'r') as json_file:
                    try:
                        # Read the content of the file
                        file_content = json_file.read()

                        # Use regular expression to find all occurrences of 
                        matches = re.findall(r'"id":(\d+),', file_content)

                        # Append the extracted integers to the list
                        integer_values.extend(map(int, matches))

                    except Exception as e:
                        print(f"Error processing {file_path}: {e}")

    return integer_values

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <directory_path>")
        sys.exit(1)

    folder_path = sys.argv[1]
    result = extract_integers_from_json(folder_path)

    print(len(result))
    result = set(result)
    print(len(result))
    result = sorted(result)
    print(len(result))
    print(result)
    np.savetxt('all_ids.txt', result, fmt='%d')

if __name__ == "__main__":
    main()

