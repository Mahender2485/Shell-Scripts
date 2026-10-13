#!/bin/bash

#factorial() {
#    echo "enter a number: "
#    read -r num
#
# if [[ "$num" =~ ^[0-9]+$ ]]; then
#
#        fact=1
#        for (( i=1; i<=num; i++ )); do
#            fact=$((fact * i))
#        done
#        echo "Factorial of $num is: $fact"
#    else
#        echo "Enter a non-negative number."
#    fi
#
#}
#
#factorial */


factorial() {
    echo "Enter a number:"
    read -r num

    if [[ "$num" =~ ^[0-9]+$ ]]; then
        fact=1

        for ((i=1; i<=num; i++)); do
            fact=$((fact * i))
        done

        echo "Factorial of $num is: $fact"
    else
        echo "Enter a valid non-negative integer."
    fi
}

factorial

