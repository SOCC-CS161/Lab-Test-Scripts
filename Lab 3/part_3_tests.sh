
#!/bin/bash

echo "-----------------------------------------------------------------------------------------"
echo "++++++++++++++++++++++++++++++++++ PART 3 (FINAL) TESTS +++++++++++++++++++++++++++++++++"
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
            #sleep 1  # Add a delay of 1 second between inputs
        done
    } | ./blackjack_game > game_output.txt

    # Check for correct card sequence using regular expressions
    if grep -qEi "$expected_cards" game_output.txt; then
        echo "✅ PASSED: Correct card sequence found."
    else
        echo "❌ FAILED: Correct card sequence not found. Searched for '$readable_expected_cards'."
    fi

    # Check for correct hand value
    if grep -qi "$expected_value" game_output.txt; then
        echo "✅ PASSED: Correct hand value found."
    else
        echo "❌ FAILED: Correct hand value not found. Expected '$expected_value'."
    fi

    # Print the program output
    echo "--------------------------------------------------"
    echo "Program Output:"
    cat game_output.txt
    echo "--------------------------------------------------"
}


# Scenario details
declare -A scenarios
scenarios["Dealer Busts"]="6 'n' '6\s*0' 'Dealer busts'"
scenarios["Dealer Wins"]="3 'n' '7\s*9' 'You lose'"
scenarios["Tie (Dealer Wins)"]="4 'n' '8\s*J' 'You lose'"
scenarios["Dealer Loses"]="54 'y n' '0\s*4\s*5' 'You win'"


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
