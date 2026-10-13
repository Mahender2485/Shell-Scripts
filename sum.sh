#!/bin/bash

add() {
  echo "Adding $1 and $2"
  sum=$(($1 + $2))
  echo "$sum"
}
read -p "Enter first number: " num1
read -p "Enter second number: " num2
result=$(add $num1 $num2)
echo "Sum of Two Numbers is: $result"
