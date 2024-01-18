#!/bin/bash

# Compile your program
g++ -o test_lab_2 ./source/main.cpp

# Define the test input and expected output
food_charge="37.45"
gratuity_percent="18"
amount_tendered="100.00"
# Assuming specific expected counts for coins and bills
expected_food_charge="\$37.45"
expected_tax="\$2.24"
expected_gratuity="\$6.74"
expected_total="\$46.43"
expected_change="\$53.57"

expected_hundreds="0"
expected_fifties="1"
expected_twenties="0"
expected_tens="0"
expected_fives="0"
expected_ones="3"
expected_quarters="2"
expected_dimes="0"
expected_nickels="1"
expected_pennies="2"

# Run the program with predefined inputs and capture the output
echo -e "$food_charge\n$gratuity_percent\n$amount_tendered" | ./test_lab_2 > output.txt

# Perform all checks
echo "--------------------------------------------------"
echo "Performing checks:"
echo "--------------------------------------------------"

check_output() {
    local pattern="$1"
    local success_message="$2"
    local fail_message="$3"
    if grep -qE "$pattern" output.txt; then
        echo "✅ PASSED: $success_message."
    else
        echo "❌ FAILED: $fail_message."
    fi
}

# Welcome message check
check_output "Welcome" "Welcome message found" "Welcome message not found. Ensure the word 'Welcome' is printed."

# Current Pacific Time check
current_time=$(TZ="America/Los_Angeles" date +"%H:%M")
current_time_optional_leading=$(TZ="America/Los_Angeles" date +"%-H:%M")
timeRegex="($current_time|$current_time_optional_leading)"
check_output "$timeRegex" "Current Pacific Time found in output" "Current Pacific Time not found in output. Expected was: '$current_time' or '$current_time_optional_leading'."

# Correct amounts and change checks
check_output "$expected_food_charge" "Correct food charge amount found" "Food charge amount not found. Expected was: '$expected_food_charge'."
check_output "$expected_tax" "Correct tax amount found" "Tax amount not found. Expected was: '$expected_tax'."
check_output "$expected_gratuity" "Correct gratuity amount found" "Gratuity amount not found. Expected was: '$expected_gratuity'."
check_output "$expected_total" "Correct total due found" "Total due not found. Expected was: '$expected_total'."
check_output "$expected_change" "Correct change found" "Change not found. Expected was: '$expected_change'."

# Coin and bill count checks
check_output "${expected_hundreds} hundred-dollar bills" "Correct count for hundred-dollar bills found" "Hundred-dollar bill count not found. Expected was: '$expected_hundreds hundred-dollar bills'."
check_output "${expected_fifties} fifty-dollar bills" "Correct count for fifty-dollar bills found" "Fifty-dollar bill count not found. Expected was: '$expected_fifties fifty-dollar bills'."
check_output "${expected_twenties} twenty-dollar bills" "Correct count for twenty-dollar bills found" "Twenty-dollar bill count not found. Expected was: '$expected_twenties twenty-dollar bills'."
check_output "${expected_tens} ten-dollar bills" "Correct count for ten-dollar bills found" "Ten-dollar bill count not found. Expected was: '$expected_tens ten-dollar bills'."
check_output "${expected_fives} five-dollar bills" "Correct count for five-dollar bills found" "Five-dollar bill count not found. Expected was: '$expected_fives five-dollar bills'."
check_output "${expected_ones} dollars" "Correct count for one-dollar bills found" "One-dollar bill count not found. Expected was: '$expected_ones dollars'."
check_output "${expected_quarters} quarters" "Correct count for quarters found" "Quarter count not found. Expected was: '$expected_quarters quarters'."
check_output "${expected_dimes} dimes" "Correct count for dimes found" "Dime count not found. Expected was: '$expected_dimes dimes'."
check_output "${expected_nickels} nickels" "Correct count for nickels found" "Nickel count not found. Expected was: '$expected_nickels nickels'."
check_output "${expected_pennies} pennies" "Correct count for pennies found" "Penny count not found. Expected was: '$expected_pennies pennies'."

# Output results
echo "--------------------------------------------------"
echo "Program Output:"
cat output.txt
echo "--------------------------------------------------"
echo "End of Output"
echo "--------------------------------------------------"
