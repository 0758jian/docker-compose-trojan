- 以google cloud 的 CentOS7 为例，前提你有VPS和有个域名绑定好IP
### 一、安装git、docker、docker-compose
- 不会安装，请查看其他项目有说明
### 二、拉取项目
```
    git clone https://github.com/0758jian/docker-compose-trojan.git trojan
```
### 三、修改caddy配置文件，让它自动生成证书，将yourdomain改为你的域名,不指定任何端口
```
    cd trojan
    vi caddy/conf/Caddyfile
    sudo docker-compose up -d caddy
    sudo docker-compose logs -f caddy
```
- 看到https://yourdomain的出现就证书生成
- 再次修改Caddyfile文件将域名指定80端口，让trojan转发过来

### 四、修改trojan配置文件的证书路径和密码，里面的yourdomain是你的域名
```
    sudo docker-compose down
    sudo docker-compose up -d
    sudo docker-compose logs trojan
```
### 五、修改mysql 端口和密码
```
    cp .env.example .env
    vi .env
```
### 注意事项
- 主要是借助caddy自动拉取证书，然后给trojan来使用，顺便开启web server伪站
- 服务器只开通80 443 22(SSH建议改为其他端口登陆)
- 已装上php 可以自行安装wordpress等php程序
- 因为没有数据库端口没暴露，所以可以装个phpmyadmin来管理数据
- trojan PC客户端下载 https://github.com/trojan-gfw/trojan/releases
- PC端会提示缺少vcruntime140_1.dll的话
- 下载https://www.dll-files.com/vcruntime140_1.dll.html
- win10复去c:\windows\system32

- TG技术群：https://t.me/joinchat/LqcgBEUJ7133BFBEv67NCw