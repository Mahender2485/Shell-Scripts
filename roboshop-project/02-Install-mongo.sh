#!/bin/bash
user_id=$(id -u)
log_dir="var/log/roboshop"
log_file="${log_dir}/${0}.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



if [ $user_id -ne 0 ]; then
    echo -e "${R}You should be root user to run this script${N}"
    exit 1
fi

mkdir -p ${log_dir}

validate() {
    if [ $1 -ne 0 ]; then
        echo -e "${2}....${R}FAILED${N}" |tee -a ${log_file}
        else
        echo -e "${2}....${G}SUCCESS${N}" |tee -a ${log_file}
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> ${log_file}
validate $? "Copying mongo.repo file"

#installing mongodb
dnf install -y mongodb-org &>> ${log_file}
validate $? "Installing MongoDB"

systemctl enable mongod &>> ${log_file}
systemctl start mongod &>> ${log_file}
validate $? "Starting MongoDB service"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
systemctl restart mongod &>> ${log_file}
validate $? "Restarting MongoDB service"
