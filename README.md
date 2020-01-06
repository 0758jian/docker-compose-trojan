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
- sha224密码生成器 https://emn178.github.io/online-tools/sha224.html
- 库表中的quota 负数就是不限流量，download + upload > quota 就断流
- trojan PC客户端下载 https://github.com/trojan-gfw/trojan/releases
- PC端会提示缺少vcruntime140_1.dll的话
- 下载https://www.dll-files.com/vcruntime140_1.dll.html
- win10复去c:\windows\system32
- 在caddy的dockerfiles文件里加入了crond、supervisord 容器启后手工执行下启动脚本吧（有时间再研究产生容器时自动运行）
```
    sudo docker-compose exec caddy sh /root/sr.sh
```
- redis的data目录要选给到权限
```
   sudo chown -R 1001:1001 redis/data/
```

- TG技术群：https://t.me/ousiqi