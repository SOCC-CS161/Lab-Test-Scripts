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

expected_hundreds="0 hundred-dollar bills"
expected_fifties="1 fifty-dollar bills"
expected_twenties="0 twenty-dollar bills"
expected_tens="0 ten-dollar bills"
expected_fives="0 five-dollar bills"
expected_ones="3 dollars"
expected_quarters="2 quarters"
expected_dimes="0 dimes"
expected_nickels="1 nickels"
expected_pennies="2 pennies"

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
    local pattern="$1"
    local success_message="$2"
    local fail_message="$3"
    if grep -qP "$pattern" output.txt; then
        echo "✅ PASSED: $success_message."
    else
        echo "❌ FAILED: $fail_message Expected was: '$pattern'."
    fi
}

# Welcome message check
check_output "Welcome" "Welcome message found" "Welcome message not found."

# Current Pacific Time check
current_time=$(TZ="America/Los_Angeles" date +"%H:%M")
# If time is like "22:9", pad with a zero to make it "22:09"
padded_time=$(echo "$current_time" | sed -r 's/:(\d)\b/:0\1/')
timeRegex="($current_time|$padded_time)"
check_output "$timeRegex" "Current Pacific Time found in output" "Current Pacific Time not found in output."

# Correct amounts and change checks
check_output "$expected_food_charge" "Correct food charge amount found" "Food charge amount not found."
check_output "$expected_tax" "Correct tax amount found" "Tax amount not found."
check_output "$expected_gratuity" "Correct gratuity amount found" "Gratuity amount not found."
check_output "$expected_total" "Correct total due found" "Total due not found."
check_output "$expected_change" "Correct change found" "Change not found."

# Coin and bill count checks
check_output "$expected_hundreds" "Correct count for hundred-dollar bills found" "Hundred-dollar bill count not found."
check_output "$expected_fifties" "Correct count for fifty-dollar bills found" "Fifty-dollar bill count not found."
check_output "$expected_twenties" "Correct count for twenty-dollar bills found" "Twenty-dollar bill count not found."
check_output "$expected_tens" "Correct count for ten-dollar bills found" "Ten-dollar bill count not found."
check_output "$expected_fives" "Correct count for five-dollar bills found" "Five-dollar bill count not found."
check_output "$expected_ones" "Correct count for one-dollar bills found" "One-dollar bill count not found."
check_output "$expected_quarters" "Correct count for quarters found" "Quarter count not found."
check_output "$expected_dimes" "Correct count for dimes found" "Dime count not found."
check_output "$expected_nickels" "Correct count for nickels found" "Nickel count not found."
check_output "$expected_pennies" "Correct count for pennies found" "Penny count not found."

# Output results
echo "--------------------------------------------------"
echo "Program Output:"
cat output.txt
echo "--------------------------------------------------"
echo "End of Output"
echo "--------------------------------------------------"
