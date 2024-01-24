#!/bin/bash

# Function to replace seed, compile, run the game, and check the results
run_test() {
    local seed=$1
    local input=$2
    local expected_cards=$3
    local expected_value=$4

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
scenarios["Blackjack on initial hand"]="68 '' 'A 0' 'Blackjack'"
scenarios["Blackjack on second hand no ace"]="29 'y\n' '4 7 0' 'Blackjack'"
scenarios["Ace revalued from 11 to 1"]="28 'y\n' 'A 9 3' '.*'"
scenarios["Bust on first hit"]="0 'y\n' 'K J 0' 'Bust'"
scenarios["Bust on second hit"]="1 'y\ny\n' '3 8 4 7' 'Bust'"
scenarios["Bust on third hit"]="9 'y\ny\ny\n' '4 3 2 K 3' 'Bust'"

# Backup main.cpp before replacement
cp main.cpp main.cpp.bak

# Run tests for each scenario
for scenario in "${!scenarios[@]}"; do
    echo "=================================================="
    echo "Testing scenario: $scenario"
    echo "=================================================="
    IFS=' ' read -ra ADDR <<< "${scenarios[$scenario]}"
    run_test "${ADDR[0]}" "${ADDR[1]}" "${ADDR[2]}" "${ADDR[3]}"
done

# Restore the original main.cpp
mv main.cpp.bak main.cpp
