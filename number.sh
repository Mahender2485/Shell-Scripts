#!/bin/bash

num(){
    echo "Enter a number:"
    read num1

    #if[ (($num1 / 2)) -eq 0 ]; then
	if [ $((num1 % 2)) -eq 0 ]; then
        echo "$num1 is even"
    else
        echo "$num1 is odd"
    fi
}
num
