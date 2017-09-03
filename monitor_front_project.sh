#!/bin/bash

#错误信息输出
function error_exit() {
   echo "--- ${1} ---"
   exit 1
}


user=$1
project_name=$2
node_port=$3
if [ -z $user ]; then
   error_exit "请传入用户名,如: ${0} user"
fi

#if [ -z $project_name ]; then
#   error_exit "请传入工程名,如: ${0} user project_name  node_port"
#fi

ps -ef|grep "${user}/htdocs/"

