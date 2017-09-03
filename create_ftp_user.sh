#!/bin/bash

# 创建前端ftp用户并添加ftp子目录


#错误信息输出
function error_exit() {
   echo "--- ${1} ---"
   exit 1
}


user=$1
if [ -z $user ]; then
echo "此脚本所做任务："
echo " 创建前端ftp用户并添加ftp子目录"
echo ""
echo "exmple: ./create_ftp_user.sh ftpuser "
exit
fi

sudo useradd $user -s /sbin/nologin || error_exit "创建用户失败"
echo "--- 成功创建用户:${user} ---"
pass="123456"
echo $pass | sudo passwd --stdin $user || error_exit "用户:${user}密码设置失败"
echo "--- 成功设置默认密码:${pass} ---"

