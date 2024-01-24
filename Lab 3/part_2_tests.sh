#!/bin/bash

# Function to replace seed, compile, run the game, and check the results
run_test() {
    local seed="$1"
    local inputs="$2"
    local expected_cards="$3"
    local expected_cards_display="$4"  # Simplified version for display
    local expected_value="$5"

    # Replace time(0) with the fixed seed value and compile from stdin
    sed "s/time(0)/$seed/" ./source/main.cpp | g++ -x c++ - -o blackjack_game || { echo "❌ COMPILATION FAILED"; exit 1; }

    # Run the game and capture the output
    {
        for (( i=0; i<${#inputs}; i++ )); do
            echo -e "${inputs:$i:1}\n"
            sleep 1  # Add a delay of 1 second between inputs
        done
    } | ./blackjack_game > game_output.txt

    # Check for correct card sequence using regular expressions
    if grep -qE "$expected_cards" game_output.txt; then
        echo "✅ PASSED: Correct card sequence found."
    else
        echo "❌ FAILED: Correct card sequence not found. Searched for '$expected_cards_display'."
    fi

    # Check for correct hand value using the exact match
    if grep -q "$expected_value" game_output.txt; then
        echo "✅ PASSED: Correct hand value found."
    else
        echo "❌ FAILED: Correct hand value not found. Searched for exact phrase '$expected_value'."
    fi

    # Print the program output
    echo "--------------------------------------------------"
    echo "Program Output:"
    cat game_output.txt
    echo "--------------------------------------------------"
}

# Scenario details with regular expression patterns and exact phrases
declare -A scenarios
scenarios["Blackjack on initial hand"]="0 '' 'A[[:space:][:punct:]]*0' 'A 0' 'Blackjack! You won!!'"
scenarios["Blackjack on second hand no ace"]="15 'y' 'J[[:space:][:punct:]]*3[[:space:][:punct:]]*8' 'J 3 8' 'Blackjack!!'"
scenarios["Ace revalued from 11 to 1"]="11 'y' '9[[:space:][:punct:]]*A[[:space:][:punct:]]*8' '9 A 8' '.*'"
scenarios["Bust on first hit"]="3 'y' '7[[:space:][:punct:]]*9[[:space:][:punct:]]*0' '7 9 0' 'Bust! You Lose!'"
scenarios["Bust on second hit"]="12 'y y' '6[[:space:][:punct:]]*3[[:space:][:punct:]]*8[[:space:][:punct:]]*8' '6 3 8 8' 'Bust! You Lose!'"
scenarios["Bust on third hit"]="8 'y y y' '2[[:space:][:punct:]]*3[[:space:][:punct:]]*8[[:space:][:punct:]]*7[[:space:][:punct:]]*K' '2 3 8 7 K' 'Bust! You lose!'"

# Run tests for each scenario
for scenario in "${!scenarios[@]}"; do
    echo "=================================================="
    echo "Testing scenario: $scenario"
    echo "=================================================="
    
    scenario_details="${scenarios[$scenario]}"
    
    # Extract seed, inputs, expected cards, display version, and values
    seed="${scenario_details%% *}"
    remaining="${scenario_details#* }"
    inputs=$(echo "$remaining" | cut -d"'" -f2)
    inputs="${inputs// /}"  # Remove spaces from inputs
    remaining=$(echo "$remaining" | cut -d"'" -f3-)
    expected_cards=$(echo "$remaining" | cut -d"'" -f1)
    expected_cards_display=$(echo "$remaining" | cut -d"'" -f2)
    expected_value=$(echo "$remaining" | cut -d"'" -f4)

    run_test "$seed" "$inputs" "$expected_cards" "$expected_cards_display" "$expected_value"
done
