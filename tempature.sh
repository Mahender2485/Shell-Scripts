#!/bin/bash

celsius_to_fahrenheit() {
    local celsius=$1
    local fahrenheit=$(echo "scale=2; ($celsius * 9/5) + 32" | bc)
    echo "$fahrenheit"
}

fahrenheit_to_celsius() {
    local fahrenheit=$1
    local celsius=$(echo "scale=2; ($fahrenheit - 32) * 5/9" | bc)
    echo "$celsius"
}

echo "Temperature Conversion Script"
echo "1. Celsius to Fahrenheit"
echo "2. Fahrenheit to Celsius"
echo "3. Exit"

echo "Enter your choice (1/2/3):"
read choice

case $choice in
    1)
        echo "Enter temperature in Celsius:"
        read celsius
        fahrenheit=$(celsius_to_fahrenheit "$celsius")
        echo "$celsius°C is equal to $fahrenheit°F"
        ;;
    2)
        echo "Enter temperature in Fahrenheit:"
        read fahrenheit
        celsius=$(fahrenheit_to_celsius "$fahrenheit")
        echo "$fahrenheit°F is equal to $celsius°C"
        ;;
    3)
        echo "Exiting the script."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run the script again and select a valid option."
        exit 1
        ;;
esac
