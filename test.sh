#!/bin/bash

echo "Enter Person 1 Name"
read P1

echo "Enter Person 2 Name"
read P2

echo "$P1 is Person1"
echo "$P2 is Person2"

echo "Script takes command line arguments from here"

Per1=$1
Per2=$2

echo "This is $Per1 from command line arguments"
echo "This is $Per2 from command line arguments"
