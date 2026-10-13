#!/bin/bash

calc() {
    echo "Enter first number:"
    read num1
    echo "Enter second number:"
    read num2
    echo "Select operation (+, -, *, /):"
    read op

    case "$op" in
        "+")
            result=$(echo "$num1 + $num2" | bc)
            ;;
        "-")
            result=$(echo "$num1 - $num2" | bc)
            ;;
        "*")
            result=$(echo "$num1 * $num2" | bc)
            ;;
        "/")
            if [ "$num2" -eq 0 ]; then
                echo "Error: Division by zero"
                return
            fi
            result=$(echo "scale=2; $num1 / $num2" | bc)
            ;;
        *)
            echo "Invalid operation"
            return
            ;;
    esac

    echo "Result: $result"
}
calc
