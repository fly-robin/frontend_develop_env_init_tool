# 前端开发环境自动化构建脚本

## 启动顺序
1. 创建FTP用户 create_ftp_user.sh
2. 配置虚拟主机并代理到前端工程 create_vhost.sh
3. 安装前端工程 init_front_project.sh
4. 启动前端工程后台进程 start_front_project.sh


# 辅助工具
1. 清空工程并重新初始化,用于上述步骤3的中途执行错误回滚 re_init_project.sh
2. 监控前端用户的进程 monitor_front_project.sh
