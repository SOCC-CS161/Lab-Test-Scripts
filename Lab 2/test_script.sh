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

echo "Running the program with the following inputs:"
echo "Food Charge = \$${food_charge}"
echo "Gratuity = ${gratuity_percent}%"
echo "Amount Tendered = \$${amount_tendered}"
echo

# Perform all checks
echo "--------------------------------------------------"
echo "Performing checks:"
echo "--------------------------------------------------"

check_output() {
    local expected="$1"
    local message="$2"
    local fail_message="$3"
    if grep -q "$expected" output.txt; then
        echo "✅ PASSED: $message."
    else
        echo "❌ FAILED: $fail_message Expected was: '$expected'."
    fi
}

# Check for welcome message, time, and formatted amounts
check_output "Welcome" "Welcome message found" "Welcome message not found."
# Allow time without leading zero
current_time=$(TZ="America/Los_Angeles" date +"%H:%M")
current_time_optional_leading=$(TZ="America/Los_Angeles" date +"%-H:%M")
timeRegex="($current_time|$current_time_optional_leading)"
check_output "$timeRegex" "Current Pacific Time found in output" "Current Pacific Time not found in output."

# Check for correct amounts and change
check_output "$expected_food_charge" "Correct food charge amount found" "Food charge amount not found."
check_output "$expected_tax" "Correct tax amount found" "Tax amount not found."
check_output "$expected_gratuity" "Correct gratuity amount found" "Gratuity amount not found."
check_output "$expected_total" "Correct total due found" "Total due not found."
check_output "$expected_change" "Correct change found" "Change not found."

# Check for coin and bill counts
check_output "${expected_hundreds} hundred-dollar bills" "Correct count for hundred-dollar bills found" "Hundred-dollar bill count not found."
check_output "${expected_fifties} fifty-dollar bills" "Correct count for fifty-dollar bills found" "Fifty-dollar bill count not found."
check_output "${expected_twenties} twenty-dollar bills" "Correct count for twenty-dollar bills found" "Twenty-dollar bill count not found."
check_output "${expected_tens} ten-dollar bills" "Correct count for ten-dollar bills found" "Ten-dollar bill count not found."
check_output "${expected_fives} five-dollar bills" "Correct count for five-dollar bills found" "Five-dollar bill count not found."
check_output "${expected_ones} dollars" "Correct count for one-dollar bills found" "One-dollar bill count not found."
check_output "${expected_quarters} quarters" "Correct count for quarters found" "Quarter count not found."
check_output "${expected_dimes} dimes" "Correct count for dimes found" "Dime count not found."
check_output "${expected_nickels} nickels" "Correct count for nickels found" "Nickel count not found."
check_output "${expected_pennies} pennies" "Correct count for pennies found" "Penny count not found."


# Output results
echo "--------------------------------------------------"
echo "Program Output:"
cat output.txt
echo "--------------------------------------------------"
echo "End of Output"
echo "--------------------------------------------------"
