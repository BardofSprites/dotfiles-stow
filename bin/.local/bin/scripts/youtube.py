import re

# Define the regular expression pattern for matching links
pattern = r'https://youtube\.com/@\w+'

# Initialize an empty list to store the matched links
links = []

# Open the file for reading
with open('trimmed.html', 'r') as file:
    # Iterate through each line in the file
    for line in file:
        # Search for links that match the pattern in the current line
        matches = re.findall(pattern, line)
        
        # If matches were found, add them to the links list
        if matches:
            links.extend(matches)

# Print the list of matched links
for link in links:
    print(link)
