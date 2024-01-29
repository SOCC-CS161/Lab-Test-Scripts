#!/bin/bash

echo "-----------------------------------------------------------------------------------------"
echo "++++++++++++++++++++++++++++++++++ PART 2 TESTS +++++++++++++++++++++++++++++++++++++++++"
echo "-----------------------------------------------------------------------------------------"

 # Check if time(0) is present in the source code
    if ! grep -q "time(0)" ./source/main.cpp; then
        echo "❌ FAILED: 'time(0)' not found in source code. Ensure srand() is properly seeded."
        exit 1  # Exit this script with an error status
    fi

    # Check if srand() is called more than once, excluding single-line comments
srand_count=$(grep -v "^\s*//" ./source/main.cpp | grep -c "srand")
if [ "$srand_count" -gt 1 ]; then
    echo "❌ FAILED: srand() appears in code more than once. Ensure srand() appears only once in your code."
    exit 1  # Exit this script with an error status
fi

    
# Function to replace seed, compile, run the game, and check the results
run_test() {
    local seed="$1"
    local inputs="$2"
    local expected_cards="$3"
    local expected_value="$4"
    
    # Convert regex to readable format. Replace '\s*' with ' ' and remove escape characters
    local readable_expected_cards=$(echo "$expected_cards" | sed 's/\\s\*/ /g')

    # Replace time(0) with the fixed seed value and compile from stdin
    sed "s/time(0)/$seed/" ./source/main.cpp | g++ -x c++ - -o blackjack_game || { echo "❌ COMPILATION FAILED"; exit 1; }

    # Run the game and capture the output
    {
        for (( i=0; i<${#inputs}; i++ )); do
            echo -e "${inputs:$i:1}\n"
        done
    } | ./blackjack_game > game_output.txt

    # Check for correct card sequence using regular expressions
    if grep -qEi "$expected_cards" game_output.txt; then
        echo "✅ PASSED: Correct card sequence found."
    else
        echo "❌ FAILED: Correct card sequence not found. Searched for '$readable_expected_cards'."
    fi

    # Check for correct game outcome
    if grep -qi "$expected_value" game_output.txt; then
        echo "✅ PASSED: Correct game outcome found."
    else
        echo "❌ FAILED: Correct game outcome not found. Expected '$expected_value'."
    fi

    # Print the program output
    echo "--------------------------------------------------"
    echo "Program Output:"
    cat game_output.txt
    echo "--------------------------------------------------"
}


# Scenario details
declare -A scenarios
scenarios["Blackjack on initial hand"]="0 '' 'A\s*0' 'Blackjack'"
scenarios["Blackjack on second hand no ace"]="15 'y' 'J\s*3\s*8' 'Blackjack'"
scenarios["Ace revalued from 11 to 1"]="11 'y' '9\s*A\s*8' '.*'"
scenarios["Bust on first hit"]="3 'y' '7\s*9\s*0' 'Bust'"
scenarios["Bust on second hit"]="12 'y y' '6\s*3\s*8\s*8' 'Bust'"
scenarios["Bust on third hit"]="8 'y y y' '2\s*3\s*5\s*7\s*K' 'Bust'"

# Run tests for each scenario
for scenario in "${!scenarios[@]}"; do
    echo "=================================================="
    echo "Testing scenario: $scenario"
    echo "=================================================="
    
    scenario_details="${scenarios[$scenario]}"
    
    # Extract seed
    seed="${scenario_details%% *}"
    scenario_details="${scenario_details#* }"
    
    # Extract inputs
    inputs=$(echo "$scenario_details" | cut -d"'" -f2)  # Get the input part
    inputs="${inputs// /}"  # Remove spaces from inputs
    
    # Extract expected cards and values
    expected_cards=$(echo "$scenario_details" | cut -d"'" -f4)
    expected_value=$(echo "$scenario_details" | cut -d"'" -f6)

    run_test "$seed" "$inputs" "$expected_cards" "$expected_value"
done
