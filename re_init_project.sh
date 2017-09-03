#!/bin/bash
#重新初始化vhost目录
echo '请传入工程路径以便重新初始化'
read vhost_path
if [ -z $vhost_path ]; then
   echo '不能为空'
   exit
fi

rm -rf $vhost_path
mkdir $vhost_path
touch "${vhost_path}/index.html" && echo "初始化成功"

