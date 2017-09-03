#!/bin/bash

# 此脚本用于自动化初始前端工程开发调试环境，具体将完成:
# 1. 基于用户目录拉取工程代码
# 2. 安装前端工程
# 3. 设置前端文件所有者为用户本人
# 4. 修改前端端口配置文件config/index.js并设为只读
# 5. 尝试启动前端工程


#错误信息输出
function error_exit() {
   echo "--- ${1} ---"
   exit 1
}

user=$1
project_name=$2
node_port=$3
if [ -z $user ]; then
   error_exit "请传入用户名,如: ${0} user project_name node_port"
fi

if [ -z $project_name ]; then
   error_exit "请传入工程名,如: ${0} user project_name  node_port"
fi

if [ -z $node_port ]; then
   error_exit "请传入监听端口号,如: ${0} user project_name node_port"
fi

# 用户目录
user_home_path=`sh -c "echo ~${user}"/`
if [ ! -d $user_home_path ]; then
   error_exit "用户不存在: ${user} "
fi


# 1.拉取工程代码,切换到需要部署的指定分支
htdocs_path="${user_home_path}/htdocs/"
if [ ! -d $htdocs_path ]; then
   mkdir $htdocs_path || error_exit "${htdocs_path}创建失败 "
fi
project_path="${htdocs_path}${project_name}/"
cd $htdocs_path
echo "请输入git仓库地址:"
read git_url
rm "${project_path}index.html" -r || error_exit "删除工程默认文件失败"
git clone $git_url || error_exit "初始代码拉取失败"

cd $project_path
echo ""
echo "当前工程中的分支有:"
git branch -r
echo "请输入需要部署的分支:"
read branch
if [ -z $branch ]; then
   branch='develop'
   echo "你输入的分支名为空，默认使用${branch}分支"
fi
git checkout $branch || error_exit "用户开发分支不存在"
echo "--- ${project_name} 代码拉取成功,并已切换到${branch}分支 --- "

cd $project_path
# 2. 归还目录权限给用户
chown $user:$user ./ -R
# 3. npm初始化安装前端工程
cnpm i || error_exit "前端工程安装失败"

# 4. 修改监听端口
config_path="${project_path}config/index.js"
sed -i "s/port\: [0-9]\{0,5\}\,/port\: ${node_port}\,/g" $config_path || error_exit "监听端口修改失败"
chmod =r $config_path
echo --- 监听端口已改为: ${node_port} ---""


# 5. 开始尝试启动
echo ""
echo "--- 开始尝试启动 --- "
npm run dev && echo "--- 启动成功 ---"

