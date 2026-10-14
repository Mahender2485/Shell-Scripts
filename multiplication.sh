#!/bin/bash

multiplication() {
    echo "Enter number for multiplication table: "
    read -r num
    
    for i in {1..10}
    do
        result=$((num * i))
        echo "$num x $i = $result"
    done
}
multiplication
