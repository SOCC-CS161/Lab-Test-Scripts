#!/bin/bash

# Function to replace seed, compile, run the game, and check the results
run_test() {
    local seed=$1
    local input=$2
    local expected_cards="$3"  # Enclose expected_cards in double quotes
    local expected_value="$4"  # Enclose expected_value in double quotes

    # Replace time(0) with the fixed seed value and compile from stdin
    sed "s/time(0)/$seed/" ./source/main.cpp | g++ -x c++ - -o blackjack_game || { echo "❌ COMPILATION FAILED"; exit 1; }

    # Run the game, pass the input and capture the output
    echo -e "$input" | ./blackjack_game > game_output.txt

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
scenarios["Blackjack on initial hand"]="0 \"\" \"A 0\" \"Blackjack\""
scenarios["Blackjack on second hand no ace"]="15 \"y\n\" \"J 3 8\" \"Blackjack\""
scenarios["Ace revalued from 11 to 1"]="11 \"y\n\" \"9 A 8\" \".*\""
scenarios["Bust on first hit"]="3 \"y\n\" \"7 9 0\" \"Bust\""
scenarios["Bust on second hit"]="12 \"y\ny\n\" \"6 3 8 8\" \"Bust\""
scenarios["Bust on third hit"]="8 \"y\ny\ny\n\" \"2 3 8 7 K\" \"Bust\""

# Run tests for each scenario
for scenario in "${!scenarios[@]}"; do
    echo "=================================================="
    echo "Testing scenario: $scenario"
    echo "=================================================="
    IFS=' ' read -ra ADDR <<< "${scenarios[$scenario]}"
    run_test "${ADDR[0]}" "${ADDR[1]}" "${ADDR[2]}" "${ADDR[3]}"
done
