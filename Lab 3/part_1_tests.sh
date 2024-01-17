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

# Normalize line endings to Unix format (remove carriage returns)
sed -i 's/\r$//' output.txt

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
    [10]="J"
    [10]="Q"
    [10]="K"
)

# Define the expected format regex
format_regex='^\s*([A-K0-9]|10)\s+([1-9]|10|11|12|13)\s*$|^\s*([1-9]|10|11|12|13)\s+([A-K0-9]|10)\s*$'



# Verify the mapping and format
errors=0
format_errors=0
while IFS= read -r line; do
    # Extract character and number from the line
    character=$(echo "$line" | grep -oP '^\s*\K[A-K0-9]')
    number=$(echo "$line" | grep -oP '\d+\s*$')

    if [[ -n "$number" && -n "$character" ]]; then
        if [[ "$character" =~ [JQK] && "$number" -eq 10 ]]; then
            echo "  ✅ The character \"$character\" is correctly associated with the value \"$number\"."
        elif [[ "$character" =~ [A1-9] ]]; then
            expected_value="${card_mapping[$character]}"
            if [[ "$number" != "$expected_value" ]]; then
                echo "  ❌ Expected the character \"$character\" to be associated with \"$expected_value\". Found \"$number\" instead."
                ((errors++))
            else
                echo "  ✅ The character \"$character\" appears to be correctly associated with the value \"$number\"."
            fi
        else
            echo "  ❌ The character \"$character\" is not correctly associated with any value."
            ((errors++))
        fi
    else
        echo "  ❌ The line \"$line\" does not match the expected format which is the card and its corresponding value separated by spaces or tabs; one card per line."
        ((format_errors++))
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

# Neatly print the program output
echo "--------------------------------------------------"
echo "Program Output:"
echo "--------------------------------------------------"
cat output.txt
echo "--------------------------------------------------"
echo "End of Program Output"
echo "--------------------------------------------------"
