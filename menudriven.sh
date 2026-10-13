#!/bin/bash

Addition()
{
    echo "Enter first number: "
    read num1
    echo "Enter second number: "
    read num2
    sum=$((num1 + num2))
    echo "The sum of $num1 and $num2 is: $sum"
}
Subtraction()
{
    echo "Enter first number: "
    read num1
    echo "Enter second number: "
    read num2
    difference=$((num1 - num2))
    echo "The difference of $num1 and $num2 is: $difference"
}
Multiplication()
{
    echo "Enter first number: "
    read num1
    echo "Enter second number: "
    read num2
    product=$((num1 * num2))
    echo "The product of $num1 and $num2 is: $product"
}
Division()
{
    echo "Enter first number: "
    read num1
    echo "Enter second number: "
    read num2
    if [ $num2 -eq 0 ]; then
        echo "Error: Division by zero is not allowed."
    else
        quotient=$((num1 / num2))
        echo "The quotient of $num1 and $num2 is: $quotient"
    fi
}

echo "Select an operation:"
echo "1. Addition"
echo "2. Subtraction"
echo "3. Multiplication"
echo "4. Division"
echo "5. Exit"
read choice 

case $choice in
    1)
        Addition
        ;;
    2)
        Subtraction
        ;;
    3)
        Multiplication
        ;;
    4)
        Division
        ;;
    5)
        echo "Exiting the program."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please select a valid option."
        ;;
esac
