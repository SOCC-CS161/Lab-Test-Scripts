#!/bin/bash

# Function to replace seed, compile, run the game, and check the results
run_test() {
    local seed="$1"
    local inputs="$2"
    local expected_cards="$3"
    local expected_value="$4"

    # Replace time(0) with the fixed seed value and compile from stdin
    sed "s/time(0)/$seed/" ./source/main.cpp | g++ -x c++ - -o blackjack_game || { echo "❌ COMPILATION FAILED"; exit 1; }

    # Check the inputs and run the game
    echo "Inputs: '$inputs'"  # Debug: print the inputs

    {
        for (( i=0; i<${#inputs}; i++ )); do
            echo -e "${inputs:$i:1}\n"
            sleep 1  # Add a delay of 1 second between inputs
        done
    } | ./blackjack_game > game_output.txt

    # Check for correct card sequence
    if grep -q "$expected_cards" game_output.txt; then
        echo "✅ PASSED: Correct card sequence found."
    else
        echo "❌ FAILED: Correct card sequence not found. Searched for '$expected_cards'."
    fi

    # Check for correct hand value
    if grep -q "$expected_value" game_output.txt; then
        echo "✅ PASSED: Correct hand value found."
    else
        echo "❌ FAILED: Correct hand value not found. Searched for '$expected_value'."
    fi

    # Print the program output
    echo "--------------------------------------------------"
    echo "Program Output:"
    cat game_output.txt
    echo "--------------------------------------------------"
}

# Scenario details
declare -A scenarios
scenarios["Blackjack on initial hand"]="0 '' 'A 0' 'Blackjack'"
scenarios["Blackjack on second hand no ace"]="15 'y' 'J 3 8' 'Blackjack'"
scenarios["Ace revalued from 11 to 1"]="11 'y' '9 A 8' '.*'"
scenarios["Bust on first hit"]="3 'y' '7 9 0' 'Bust'"
scenarios["Bust on second hit"]="12 'y y' '6 3 8 8' 'Bust'"
scenarios["Bust on third hit"]="8 'y y y' '2 3 8 7 K' 'Bust'"

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
