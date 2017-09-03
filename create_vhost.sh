#!/bin/bash

# 此脚本将创建nginx虚拟主机，具体如下:
# 1. 在用户目录下创建指定工程名的虚拟主机目录,规则为: ~/htdocs/project_name
# 2. 创建nginx虚拟主机配置基础配置文件,写入反向代理端口


#错误信息输出
function error_exit() {
   echo "--- ${1} ---"
   exit 1
}

function create_vhost() {
   user=$1
   if [ -z $user ]; then
      error_exit "请传入用户名,如: ${0} user1 ，新建的虚拟主机将基于该用户的家目录"
   fi

   # 用户目录
   user_home_path=`sh -c "echo ~${user}"/`
   if [ ! -d $user_home_path ]; then
      error_exit "不存在用户: ${user} path: ${user_home_path}"
   fi


   echo "请输入要新增加的虚拟主机域名:"
   read domain
   echo $read
   if [ -z $domain ]; then
      create_vhost
   fi

   echo "请输入工程名: 如, sina_finance_entrance ,建议与代码仓库名保持一致, 将作为站点绑定根路径"
   read project_name
   if [ -z $project_name ]; then
      error_exit "工程名不能为空"
   fi

   # nginx安装路径
   nginx_path="/usr/local/nginx/"
   # 虚拟主机路径(需要在nginx.conf的http中加入"include vhost.d/*.conf;" )
   vhost_dir_path="${nginx_path}conf/vhost.d/"
   # 新建的虚拟主机配置文件路径
   vhost_conf_file="${vhost_dir_path}${domain}.conf"


   if [ -f $vhost_conf_file ]; then
      error_exit "${domain} 已经存在"
   fi


   # www根路径
   htdocs_path="${user_home_path}htdocs/${project_name}/"
   if [ ! -d $htdocs_path ]; then
      mkdir $htdocs_path -p || error_exit "${htdocs_path} 创建失败"
   fi

   echo "请输入前端工程node监听端口,以作为nginx代理指向"
   read node_port
   cat>$vhost_conf_file<<EOF
server {
        listen       81;
        server_name  ${domain};

        location / {
            # 需要代理的node监听地址+端口,如http://localhost:8080
 	    proxy_pass http://localhost:${node_port};
        }
}
EOF

   echo "--- 成功创建虚拟主机 ---"
   echo " 域名: ${domain}"
   echo " 配置文件: ${vhost_conf_file}"
   echo " 站点根路径: ${htdocs_path}"
   echo " ${domain} was created!"> "${htdocs_path}index.html"

   # 目录将权限还给该用户
   chown $user:$user $htdocs_path -R || error_exit "htdocs目录权限分配失败"

   echo "--- 测试nginx虚拟主机配置文件 ---"
   "${nginx_path}sbin/nginx" -t || error_exit "配置文件错误"
  "${nginx_path}sbin/nginx" -s reload || error_exit "nginx重启失败"
   echo "--- 创建完成 --- "
   echo ""
   time=`date "+ %Y-%m-%d %H:%I:%S"`
   echo "[${time}] 用户: ${user}  工程名: ${project_name} 工程路径: ${htdocs_path} node监听: ${node_port} 域名: ${domain}  nginx配置文件路径: ${vhost_conf_file}">>/var/log/front_env/create_host.log
}

create_vhost $1
