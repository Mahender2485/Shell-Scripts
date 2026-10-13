#!/bin/bash

calculate() {
    num1=$1
    Operator=$2
    num2=$3

    case "$operator" in
        "+")
            echo "Result: $((num1 + num2))"
            ;;
        "-")
            echo "result=$((num1 - num2))"
            ;;
        "*")
            echo "result=$((num1 * num2))"
            ;;
        "/")
            if [ "$num2" -ne 0 ]; then
                echo "result=$((num1 / num2))"
            else
                echo "Error: Division by zero"
                exit 1
            fi
            ;;
        "%")
            if [ "$num2" -ne 0 ]; then
                echo "result=$((num1 % num2))"
            else
                echo "Error: Division by zero"
                exit 1
            fi
            ;;
        *)
            echo "Error: Invalid operator"
            exit 1
            ;;
    esac
}

read -p "Enter first number: " num1
read -p "Enter operator (+, -, *, /): " operator
read -p "Enter second number: " num2
calculate $num1 $operator $num2
