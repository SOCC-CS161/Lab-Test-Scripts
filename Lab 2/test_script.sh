#!/bin/bash

# Compile your program
g++ -o myprogram ./source/main.cpp

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
echo -e "$food_charge\n$gratuity_percent\n$amount_tendered" | ./myprogram > output.txt

echo "Running the program with the following inputs:"
echo "Food Charge = \$${food_charge}"
echo "Gratuity = ${gratuity_percent}%"
echo "Amount Tendered = \$${amount_tendered}"
echo
echo "--------------------------------------------------"
echo "Performing checks for PART 1:"
echo "--------------------------------------------------"
# Check for welcome message
if grep -q "Welcome" output.txt; then
    echo "✅ PASSED: Welcome message found."
else
    echo "❌ FAILED: Welcome message not found. Ensure the word \"Welcome\" is printed."
fi

# Check for time in the output
# Function to determine if PDT is in effect
is_daylight_saving() {
    local month=$(date +%m)
    local day=$(date +%d)
    local hour=$(date +%H)
    
    # Assuming daylight saving time starts on the second Sunday in March
    # and ends on the first Sunday in November
    if [ "$month" -gt 3 ] && [ "$month" -lt 11 ]; then
        return 0 # True, PDT is in effect
    elif [ "$month" -eq 3 ] && ([ "$day" -gt 7 ] || ([ "$day" -eq 7 ] && [ "$hour" -ge 2 ])); then
        return 0 # True, PDT is in effect
    elif [ "$month" -eq 11 ] && ([ "$day" -lt 7 ] || ([ "$day" -eq 7 ] && [ "$hour" -lt 2 ])); then
        return 0 # True, PDT is in effect
    else
        return 1 # False, PST is in effect
    fi
}

# Check for time in the output
current_time=$(TZ="America/Los_Angeles" date +"%H:%M")
# Create a regex that makes leading zeros optional
timeRegex="0?$(echo "$current_time" | sed 's/0\([0-9]\):/0?\1:/; s/:0\([0-9]\)$/:0?\1/')"
if grep -qE "$timeRegex" output.txt; then
    echo "✅ PASSED: Current Pacific Time found in output."
else
    echo "❌ FAILED: Expected to find current Pacific Time \"$current_time\" in output."
fi


echo "--------------------------------------------------"
echo "Performing checks for PART 2:"
echo "--------------------------------------------------"

# Check for correct food charge amount
if grep -q ${expected_food_charge} output.txt; then
    echo "✅ PASSED: Correct food charge amount found."
else
    echo "❌ FAILED: Expected to find \"${expected_food_charge}\" as food charge amount."
fi

# Check for correct tax amount (6% of 13.45 = 0.807, truncated to 0.80)
if grep -q ${expected_tax} output.txt; then
    echo "✅ PASSED: Correct tax amount found."
else
    echo "❌ FAILED: Expected to find \"${expected_tax}\" as tax amount."
fi

# Check for correct gratuity amount (15% of 13.45 = 2.0175, truncated to 2.01)
if grep -q "${expected_gratuity}" output.txt; then
    echo "✅ PASSED: Correct gratuity amount found."
else
    echo "❌ FAILED: Expected to find \"${expected_gratuity}\" as gratuity amount."
fi

# Total check
if grep -q "${expected_total}" output.txt; then
echo "✅ PASSED: Correct total due found."
else
echo "❌ FAILED: Expected to find \"${expected_total}\" printed as total due."
fi

echo "--------------------------------------------------"
echo "Performing checks for PART 3:"
echo "--------------------------------------------------"

# Change
if grep -q "${expected_change}" output.txt; then
echo "✅ PASSED: Correct total due found."
else
echo "❌ FAILED: Expected to find \"${expected_change}\" printed as total due."
fi

echo "--------------------------------------------------"
echo "Performing checks for EXTRA CREDIT:"
echo "--------------------------------------------------"

# Separate checks for each coin and bill type
check_bill_or_coin() {
    expected_count=$1
    denomination=$2
    if grep -q "${expected_count} ${denomination}" output.txt; then
        echo "✅⭐ PASSED: Correct count for ${denomination} found."
    else
        echo "❌ FAILED: Expected \"${expected_count} ${denomination}\"."
    fi
}

# Perform checks for each type
check_bill_or_coin "$expected_hundreds" "hundred-dollar bills"
check_bill_or_coin "$expected_fifties" "fifty-dollar bills"
check_bill_or_coin "$expected_twenties" "twenty-dollar bills"
check_bill_or_coin "$expected_tens" "ten-dollar bills"
check_bill_or_coin "$expected_fives" "five-dollar bills"
check_bill_or_coin "$expected_ones" "dollars"
check_bill_or_coin "$expected_quarters" "quarters"
check_bill_or_coin "$expected_dimes" "dimes"
check_bill_or_coin "$expected_nickels" "nickels"
check_bill_or_coin "$expected_pennies" "pennies"

echo
echo "--------------------------------------------------"
echo "Program Output:"
echo "--------------------------------------------------"
cat output.txt
echo
echo "--------------------------------------------------"
echo "End of Output"
echo "--------------------------------------------------"
