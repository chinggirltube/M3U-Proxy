#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 版本信息
VERSION="1.0"
AUTHOR="hiyuelin"
TELEGRAM="https://t.me/hiyuelin"

print_logo() {
    echo -e "${CYAN}"
    echo "M3U Proxy Installer"
    echo -e "${NC}"
    echo -e "${YELLOW}Version: ${VERSION}${NC}"
    echo -e "${YELLOW}Author: ${AUTHOR}${NC}"
    echo -e "${YELLOW}Telegram: ${TELEGRAM}${NC}"
}

print_menu() {
    clear
    print_logo
    echo -e "${PURPLE}=== M3U Proxy 管理菜单 ===${NC}"
    echo -e "${BLUE}1)${NC} 部署 M3U Proxy"
    echo -e "${BLUE}2)${NC} 删除 M3U Proxy"
    echo -e "${RED}0)${NC} 退出"
    echo
}

check_and_install_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker 未安装，正在安装...${NC}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        echo -e "${GREEN}Docker 安装完成${NC}"
    else
        echo -e "${GREEN}Docker 已安Docekr${NC}"
    fi
}

check_and_install_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${YELLOW}Docker Compose 未安装，正在安装...${NC}"
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo -e "${GREEN}Docker Compose 安装完成${NC}"
    else
        echo -e "${GREEN}Docker Compose 已安装${NC}"
    fi
}

deploy_m3u_proxy() {
    echo -e "${GREEN}开始部署 M3U Proxy...${NC}"
    
    # 检查并安装 Docker 和 Docker Compose
    check_and_install_docker
    check_and_install_docker_compose
    
    # 1. 指定目录
    read -p "请指定一个目录用于存放 M3U Proxy 文件 (默认 /home/m3u-proxy): " m3u_dir
    m3u_dir=${m3u_dir:-/home/m3u-proxy}
    
    # 2. 创建必要的文件
    mkdir -p $m3u_dir
    touch $m3u_dir/iptv.m3u $m3u_dir/whitelist.txt $m3u_dir/ip_whitelist.txt $m3u_dir/m3u_proxy.log $m3u_dir/security_config.json
    
    # 3. 设置端口
    read -p "请输入要使用的端口 (默认 5001): " port
    port=${port:-5001}
    
    # 4. 自动获取服务器 IP 地址并生成代理服务器地址
    echo "正在尝试获取服务器 IP 地址..."
    server_ip=$(wget -qO- -4 ifconfig.me 2>&1 || curl -s4 ifconfig.me || dig +short myip.opendns.com @resolver1.opendns.com)
    if [ -z "$server_ip" ]; then
        echo -e "${RED}无法自动获取服务器 IP 地址${NC}"
        read -p "请手动输入服务器 IP 地址: " server_ip
    else
        echo -e "检测到的服务器 IP 地址: ${YELLOW}${server_ip}${NC}"
    fi

    # 构建代理服务器地址
    proxy_server="http://${server_ip}:${port}"
    echo -e "代理服务器地址: ${YELLOW}${proxy_server}${NC}"

    # 5. 设置管理员账户和密码
    read -p "请设置管理员用户名 (默认 admin): " admin_username
    admin_username=${admin_username:-admin}
    read -p "请设置管理员密码 (默认 admin123): " admin_password
    admin_password=${admin_password:-admin123}
    
    # 创建 docker-compose.yml 文件
    cat > $m3u_dir/docker-compose.yml <<EOL
version: '3'

services:
  m3u-proxy:
    image: hiyuelin/m3u-proxy:latest
    ports:
      - "${port}:5612"
    volumes:
      - ./iptv.m3u:/app/iptv.m3u
      - ./whitelist.txt:/app/whitelist.txt
      - ./ip_whitelist.txt:/app/ip_whitelist.txt
      - ./m3u_proxy.log:/app/m3u_proxy.log
      - ./security_config.json:/app/security_config.json
    environment:
      - PROXY_SERVER=${proxy_server}
      - DEBUG_MODE=False
      - ENABLE_IP_WHITELIST=False
      - CONSOLE_LOG_ENABLED=True
      - LOG_LEVEL=INFO
      - ORIGINAL_M3U_PATH=/app/iptv.m3u
      - WHITE_LIST_PATH=/app/whitelist.txt
      - IP_WHITELIST_PATH=/app/ip_whitelist.txt
      - LOG_FILE_PATH=/app/m3u_proxy.log
      - PORT=5612
      - HOST=0.0.0.0
      - ADMIN_USERNAME=${admin_username}
      - ADMIN_PASSWORD=${admin_password}
    restart: unless-stopped
EOL

    # 启动服务
    cd $m3u_dir
    docker-compose up -d
    
    echo -e "${GREEN}M3U Proxy 部署完成${NC}"
    echo -e "管理界面地址: ${YELLOW}${proxy_server}/admin${NC}"
    echo -e "用户名: ${YELLOW}${admin_username}${NC}"
    echo -e "密码: ${YELLOW}${admin_password}${NC}"
    echo
    echo -e "${CYAN}重要提示：${NC}"
    echo -e "1. 请在 ${YELLOW}${m3u_dir}/iptv.m3u${NC} 文件中添加您要代理的频道列表，或上传您的 iptv.m3u 文件替换现有文件。"
    echo -e "2. ${YELLOW}${m3u_dir}/ip_whitelist.txt${NC} 用于管理 IP 白名单。"
    echo -e "3. ${YELLOW}${m3u_dir}/whitelist.txt${NC} 用于管理域名白名单。"
    echo -e "4. 每次更新 iptv.m3u 文件后，请在管理面板中点击"刷新域名白名单"按钮以更新白名单。"
    echo -e "5. 代理后的 M3U 文件地址: ${YELLOW}${proxy_server}/iptv.m3u${NC}"
    echo
    echo -e "${YELLOW}注意：${NC}更新 iptv.m3u 文件后，请务必在管理面板中刷新域名白名单，以确保新添加的频道能够正常工作。"
    echo -e "${YELLOW}提示：${NC}在您的播放器中使用代理后的 M3U 文件地址来访问经过代理的频道列表。"
    echo
    read -p "按回车键继续..."
}

remove_m3u_proxy() {
    echo -e "${YELLOW}正在删除 M3U Proxy...${NC}"
    read -p "请输入 M3U Proxy 的安装目录 (默认 /home/m3u-proxy): " m3u_dir
    m3u_dir=${m3u_dir:-/home/m3u-proxy}
    
    if [ -f "$m3u_dir/docker-compose.yml" ]; then
        cd $m3u_dir
        echo -e "${YELLOW}停止并删除 M3U Proxy 容器...${NC}"
        docker-compose down
        
        echo -e "${YELLOW}删除 M3U Proxy 镜像...${NC}"
        docker rmi hiyuelin/m3u-proxy:latest
        
        echo -e "${YELLOW}删除 docker-compose.yml 文件...${NC}"
        rm docker-compose.yml
        
        echo -e "${GREEN}M3U Proxy 已成功删除（包括容器和镜像）${NC}"
    else
        echo -e "${RED}未找到 M3U Proxy 的 docker-compose.yml 文件，删除失败${NC}"
    fi
    
    read -p "是否要删除 M3U Proxy 的配置文件和日志？(y/N): " delete_config
    if [[ $delete_config =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}删除配置文件和日志...${NC}"
        rm -f $m3u_dir/iptv.m3u $m3u_dir/whitelist.txt $m3u_dir/ip_whitelist.txt $m3u_dir/m3u_proxy.log $m3u_dir/security_config.json
        echo -e "${GREEN}配置文件和日志已删除${NC}"
    fi
    
    read -p "按回车键继续..."
}

# 主程序
while true; do
    print_menu
    read -p "请输入选项数字: " choice
    case $choice in
        1) deploy_m3u_proxy ;;
        2) remove_m3u_proxy ;;
        0) 
            echo -e "${GREEN}感谢使用，再见！${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选项，请重新选择${NC}"
            read -p "按回车键继续..."
            ;;
    esac
done
