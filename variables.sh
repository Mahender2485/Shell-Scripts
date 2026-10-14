#!/bin/bash
# Special Variables

echo "The name of the script is: $0"
echo "The first argument is: $1"
echo "The second argument is: $2"
echo "All arguments passed to script: $@"
echo "The number of arguments is: $#"
echo "The process ID of the script is: $$"
echo "The exit status of the last command is: $?"
echo "The current user is: $USER"
echo "The current working directory is: $PWD"
echo "Real path of the script is: $(realpath $0)"
echo "home directory of the current user is: $HOME"
echo "The current shell is: $SHELL"
echo "The current date and time is: $(date)"
sleep 50 &
echo "The last background process ID is: $!"
wait $!
echo "The last command executed in the background is: $BASHPID"
echo "The last command executed in the foreground is: $BASH_COMMAND"
echo "time taken to execute the script is: $SECONDS"
