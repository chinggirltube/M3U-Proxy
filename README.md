##一键脚本
```
bash <(curl -s https://raw.githubusercontent.com/chinggirltube/M3U-Proxy/refs/heads/main/m3u_proxy_installer.sh)
```

# M3U 代理服务器使用说明

M3U Proxy 是专为解决地理限制问题而设计。它通过在可访问区域部署代理服务器，巧妙地绕过了内容提供商的地域限制。用户只需将本地播放器连接到这个代理服务器，就能享受原本无法直接访问的节目。
这个工具的核心优势在于：

突破地理封锁：让用户能够观看原本因地理位置而被限制的内容。
简单易用：无需复杂设置，只需更改播放器中的 M3U 链接即可。

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



祝您使用愉快！