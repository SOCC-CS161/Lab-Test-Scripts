#!/bin/bash

# Print the current working directory
echo "Current working directory: $(pwd)"

# Compile the program and check for errors
g++ -o card_generator ./source/main.cpp || { echo "Compilation failed";}

# Set execute permissions
#chmod +x card_generator

# Check if the executable exists
if [ ! -f card_generator ]; then
    echo "The executable does not exist in the directory."
    exit 1
fi

# Run the program and capture the output
echo "Running the card_generator..."
./card_generator > output.txt

# Check if output is empty
if [ ! -s output.txt ]; then
    echo "❌ The output is empty. The program did not print anything."
    exit 1
fi
 
# Define the expected mapping
declare -A card_mapping=(
    [1]="A"
    [2]="2"
    [3]="3"
    [4]="4"
    [5]="5"
    [6]="6"
    [7]="7"
    [8]="8"
    [9]="9"
    [10]="0"
    [11]="J"
    [12]="Q"
    [13]="K"
)

# Define the expected format regex
format_regex='^([1-9]|10|11|12|13)[\s\-\t]+[A-K0-9]$'

# Verify the mapping and format
errors=0
format_errors=0
while IFS= read -r line; do
    # Check the format
    if ! [[ $line =~ $format_regex ]]; then
        echo "  ❌ The line \"$line\" does not match the expected format."
        ((format_errors++))
        continue
    fi

    # Extract number and character from the line
    number=$(echo "$line" | grep -oP '^\d+')
    character=$(echo "$line" | grep -oP '[A-K0-9]$')

    if [[ -n "$number" && -n "$character" ]]; then
        expected_character="${card_mapping[$number]}"
        if [[ "$character" != "$expected_character" ]]; then
            echo "  ❌ Expected \"$number\" to be associated with \"$expected_character\". Found \"$character\" instead."
            ((errors++))
        else
            echo "  ✅ The number \"$number\" appears to be correctly associated with the character \"$character\"."
        fi
    fi
done < output.txt

# Summary of the results
if [[ $format_errors -ne 0 ]]; then
    echo "❌ There were $format_errors formatting errors. Check the details above."
elif [[ $errors -eq 0 ]]; then
    echo "✅ All numbers are correctly associated with their characters and the format is correct."
else
    echo "❌ There were $errors incorrect associations. Check the details above."
fi
