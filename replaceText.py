import os
import re

def replace_in_file(filename, search_string, replace_string):
    with open(filename, 'r', encoding='utf-8') as file:
        contents = file.read()
        
    # Count how many replacements would be made using a case-insensitive search
    pattern = re.compile(re.escape(search_string), re.IGNORECASE)
    count = len(pattern.findall(contents))

    if count:
        # Make the replacement
        contents = pattern.sub(replace_string, contents)
        with open(filename, 'w', encoding='utf-8') as file:
            file.write(contents)
        print(f'Replaced {count} occurrence(s) in {filename}')

    return count

def main():
    # 1. Ask for the directory
    directory = input("Please provide the directory path: ")

    # 2. Ask for the search and replace strings
    search_string = input("Enter the search string: ")
    replace_string = input("Enter the replace string: ")

    total_replacements = 0

    # 3. Recursively traverse the directory for HTML and CSS files
    for dirpath, dirnames, filenames in os.walk(directory):
        for filename in filenames:
            if filename.endswith(('.html', '.css')):
                full_path = os.path.join(dirpath, filename)
                total_replacements += replace_in_file(full_path, search_string, replace_string)

    # 4. Print the total number of replacements
    print(f"\nTotal replacements made: {total_replacements}")

if __name__ == "__main__":
    main()
