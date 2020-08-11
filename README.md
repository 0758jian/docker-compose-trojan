- 以CentOS7 为例，前提你有VPS和有个域名绑定好IP
### 一、安装git、docker、docker-compose
- 不会安装，请查看其他项目有说明
### 二、拉取项目
```
    git clone -b trojan-nginx https://github.com/0758jian/docker-compose-trojan.git trojan
```

### 三、注意！修改trojan配置文件的证书路径和密码，里面的yourdomain是你的域名
```
    #重启服务
    sudo docker-compose down
    sudo docker-compose up -d
    sudo docker-compose logs trojan
```

### 四、先登陆cloudflare 开启global key 配置在env环境文件里，域名解析好 *.yourdomain.cc yourdomain.cc
```
    #获取一级域名和泛域名证书
    sudo docker-compose exec acme --issue --dns dns_cf -d *.yourdomain.cc -d yourdomain.cc
```

### 注意事项
- acme拉取域名证书，顺便开启web server伪站
- 已装上php 可以自行安装wordpress等php程序
- 服务器只开通80 443 8443 22(SSH建议改为其他端口登陆)
- trojan 客户端下载 https://github.com/trojan-gfw/trojan/releases

- TG技术群：https://t.me/ousiqi