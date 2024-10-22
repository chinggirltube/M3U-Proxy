AI代写

## 一键部署脚本
```
bash <(curl -s https://raw.githubusercontent.com/chinggirltube/M3U-Proxy/refs/heads/main/m3u_proxy_installer.sh)
```

# M3U 代理服务器使用说明

M3U Proxy 是专为解决地理限制问题而设计。它通过在可访问区域部署代理服务器，巧妙地绕过了内容提供商的地域限制。用户只需将本地播放器连接到这个代理服务器，就能享受原本无法直接访问的节目。

## 主要功能

1. **代理 M3U 播放列表**：实时更新您的频道列表，确保您始终能访问最新的内容。
2. **域名白名单**：允许您控制哪些域名可以被代理访问，增加安全性。
3. **IP 白名单**：限制只有特定的 IP 地址可以访问您的播放列表，提供额外的安全层。
4. **管理界面**：提供一个用户友好的界面，让您可以轻松管理服务器设置、查看统计信息等。
5. **日志记录**：记录重要事件和错误，帮助您监控和排查问题。

## 安装步骤

1. **准备工作**
   - 确保您的系统已安装 Docker 和 Docker Compose。
   - 准备好您的 M3U 播放列表文件。

2. **安装过程**
   - 运行安装脚本，选择"Docker 管理"菜单。
   - 在子菜单中选择"部署 M3U Proxy"选项。
   - 按照提示输入必要的信息（如安装目录、端口号等）。
   - 脚本会自动完成安装和配置过程。

3. **安装后配置**
   - 安装完成后，您会看到管理界面的地址、用户名和密码。
   - 使用这些信息登录管理界面，进行进一步的设置。

## 使用说明

1. **添加频道列表**
   - 将您的频道列表添加到 `iptv.m3u` 文件中，或者上传您自己的 `iptv.m3u` 文件替换现有文件。

2. **管理白名单**
   - 使用 `whitelist.txt` 文件管理域名白名单。
   - 使用 `ip_whitelist.txt` 文件管理 IP 白名单。

3. **更新白名单**
   - 每次修改 `iptv.m3u` 文件后，请在管理界面中点击"刷新域名白名单"按钮。

4. **使用代理后的播放列表**
   - 在您的播放器中使用新的 M3U 文件地址（形如 `http://您的服务器IP:端口/iptv.m3u`）。

## 注意事项

- 确保您的防火墙允许访问您设置的端口。
- 定期检查日志文件，了解服务器的运行状况。
- 保持您的 Docker 和 M3U Proxy 更新到最新版本，以获得最佳性能和安全性。

## 故障排除

如果遇到问题：
1. 检查 Docker 容器是否正在运行。
2. 查看日志文件中是否有错误信息。
3. 确保所有必要的文件都存在于指定的目录中。
4. 检查您的网络连接和防火墙设置。

## 安全建议

- 定期更改管理员密码。
- 谨慎使用 IP 白名单功能，确保不会意外锁定自己。(在管理面板添加自己的IP)
- 只添加您M3U列表里的域名或者IP到白名单中。


### 访问管理界面

启动容器后，您可以通过浏览器访问管理界面：

http://您的服务器IP:5001/admin

使用您设置的管理员用户名和密码登录。


## 如果您希望手动部署

### 准备工作

1. 确保您的系统已安装 Docker。
2. 准备好您的 M3U 播放列表文件。

### 文件准备

在您的主机上创建一个目录（例如 /home/m3u-proxy）用于存放必要的文件：
```
mkdir -p /home/m3u-proxy
```
```
cd /home/m3u-proxy
```
```
touch iptv.m3u whitelist.txt ip_whitelist.txt m3u_proxy.log
```
将您的 M3U 播放列表内容复制到 iptv.m3u 文件中。
或者直接上传你的iptv.m3u文件到目录。

### 使用 docker run 命令启动

使用以下命令启动容器：

```
docker run -d \
  --name m3u-proxy \
  -p 5001:5612 \
  -v /home/m3u-proxy/iptv.m3u:/app/iptv.m3u \
  -v /home/m3u-proxy/whitelist.txt:/app/whitelist.txt \
  -v /home/m3u-proxy/ip_whitelist.txt:/app/ip_whitelist.txt \
  -v /home/m3u-proxy/m3u_proxy.log:/app/m3u_proxy.log \
  -e PROXY_SERVER=http://您的服务器:5001 \
  -e DEBUG_MODE=False \
  -e ENABLE_IP_WHITELIST=False \
  -e CONSOLE_LOG_ENABLED=True \
  -e LOG_LEVEL=INFO \
  -e ORIGINAL_M3U_PATH=/app/iptv.m3u \
  -e WHITE_LIST_PATH=/app/whitelist.txt \
  -e IP_WHITELIST_PATH=/app/ip_whitelist.txt \
  -e LOG_FILE_PATH=/app/m3u_proxy.log \
  -e PORT=5612 \
  -e HOST=0.0.0.0 \
  -e ADMIN_USERNAME=admin \
  -e ADMIN_PASSWORD=admin123 \
  --restart unless-stopped \
  hiyuelin/m3u-proxy:latest
```

执行前必须在 /home/m3u-proxy 目录新建了 以下三个文件 
whitelist.txt
ip_whitelist.txt
m3u_proxy.log
上传iptv.m3u的文件

注意：将 "您的服务器IP" 替换为您实际的服务器 IP 地址。

-p 5001:5612 \      你可以修改5001为任意没被占用的端口

-e PROXY_SERVER=http://您的服务器:5001 \   5001必须和上面的端口一致
  

### 推荐使用 docker-compose 启动

1. 在 /home/m3u-proxy 目录中创建一个名为 docker-compose.yml 的文件：
```
nano /home/m3u-proxy/docker-compose.yml
```
2. 将以下内容复制到docker-compose.yml文件中：

```
version: '3'

services:
  m3u-proxy:
    image: hiyuelin/m3u-proxy:latest  
    ports:
      - "5001:5612"
    volumes:
      - ./iptv.m3u:/app/iptv.m3u  
      - ./whitelist.txt:/app/whitelist.txt  
      - ./ip_whitelist.txt:/app/ip_whitelist.txt  
      - ./m3u_proxy.log:/app/m3u_proxy.log  
    environment:
      - PROXY_SERVER=http://您的服务器:5001  # 设置代理服务器地址为您的服务器IP
      - DEBUG_MODE=False    
      - ENABLE_IP_WHITELIST=False  
      - CONSOLE_LOG_ENABLED=True   
      - LOG_LEVEL=INFO      
      - ORIGINAL_M3U_PATH=/app/iptv.m3u  
      - WHITE_LIST_PATH=/app/whitelist.txt  
      - IP_WHITELIST_PATH=/app/ip_whitelist.txt  
      - LOG_FILE_PATH=/app/m3u_proxy.log  
      - PORT=5612  # 保持这个不变,因为它是容器内部的端口
      - HOST=0.0.0.0  
      - ADMIN_USERNAME=admin  # 设置管理员用户名
      - ADMIN_PASSWORD=admin123  # 设置管理员密码
    restart: unless-stopped  

```

注意：将 "您的服务器IP" 替换为您实际的服务器 IP 地址。

3. 保存文件并退出编辑器。

4. 在docker-compose.yml目录创建

```
touch whitelist.txt ip_whitelist.txt m3u_proxy.log
```

whitelist.txt
ip_whitelist.txt
m3u_proxy.log
必须上传了iptv.m3u的文件

5. 在 /home/m3u-proxy 目录中运行以下命令启动容器：

```
docker-compose up -d
```


### 访问管理界面

启动容器后，您可以通过浏览器访问管理界面：

http://您的服务器IP:5001/admin

使用您设置的管理员用户名和密码登录。

祝您使用愉快！
