#!/bin/bash

# 启动前端工程
#
# 用法: ./start.sh user project
#


#错误信息输出
function error_exit() {
   echo "--- ${1} ---"
   exit 1
}

user=$1
if [ -z $user ]; then
   error_exit "请传入需要启动的工程所属的用户,如: ${0} user project"
fi

project=$2
if [ -z $project ]; then
   error_exit "请传入需要启动的工程名,如: ${0} user project"
fi

user_home_path=`sh -c "echo ~${user}"`
project_path="${user_home_path}/htdocs/${project}/"
echo "工程启动路径: ${project_path}"
cd $project_path || error_exit "工程不存在"

log_path='/var/log/front_env/'
if [ ! -d $log_path ]; then
   mkdir $log_path && echo "已创建${log_path}"
fi
log_path="${log_path}`date "+%Y%m%d"`-${user}-${project}.log"
echo "see log: ${log_path}"
echo "" >>$log_path
echo " ">>$log_path
echo "`date "+%Y-%m-%d %H:%i:s"`启动:" >>$log_path
nohup npm run dev > $log_path &


