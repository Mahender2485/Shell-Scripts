#!/bin/bash
user_id=$(id -u) #user ID to Run the commands
log_dir="/var/log/shell-scripts" #Log Directory
log_file="${log_dir}/${0}.log" #Log File Name

# Color Coding

R="\e[31m" # Red
G="\e[32m" # Green
Y="\e[33m" # Yellow
N="\e[0m" # No Color
P="\e[35m" # Purple

mkdir -p ${log_dir} #Create Log Directory if not exists

echo "Script Started execution at $(date)" &>> $log_file

if [ ${user_id} -ne 0 ]; then
    echo -e "${R}Please run the script as root user${N}" &>> $log_file
    exit 1
fi

validate(){
    if [ $1 -ne 0 ]; then
        echo -e "${2}....${R}FAILED${N}" | tee -a $log_file
        else
        echo -e "${2}....${G}SUCCESS${N}" | tee -a $log_file
    fi
}

for package in $@
do
	dnf list installed $package &>> $log_file
 		if [ $? -ne 0 ];then
    			echo -e "Package not found.... proceeding to install ${P} $package ${N}"  | tee -a $log_file
    				dnf install -y $package &>> $log_file
    			validate $? "Installing ${package}"
		else
    			echo -e "Package ${P} $package ${N} is already installed..... ${Y}SKIPPINN${N} " |tee -a $log_file
    		fi
done
