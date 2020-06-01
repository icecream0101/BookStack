### 概述
   主要针对BookStack的官方版本做了中文版构建。
- [BookStack GitHub](https://github.com/BookStackApp/BookStack)
- [BookStack官方文档](https://www.bookstackapp.com/docs/)

### Docker方式
    官方提供2个版本的镜像，由于solidnerd会报qt的错误，最后选择了linuxserver版本:
- [LinuxServer.io](https://github.com/linuxserver/docker-bookstack) 
- [solidnerd](https://github.com/solidnerd/docker-bookstack)
    
1. 镜像构建
- 官方镜像没有中文字体，导出会乱码
- 故在官方镜像基础上添加中文字体，构建的Dockerfile如下：
```dockerfile
# 官方镜像v0.29.3
FROM linuxserver/bookstack:v0.29.3-ls93

MAINTAINER icecream@qq.com

# 安装字体
RUN mkdir -p /usr/share/fonts/chinese/TrueType/ 
COPY msyh.ttf /usr/share/fonts/chinese/TrueType/
```
- 微软雅黑字体,msyh.ttf已上传至根目录

- 命令构建
```bash
#构建
docker build -f Dockerfile -t bookstack:1.0.0 .
```

2. 应用启动
- 采用mysql:5.7.30版本
- 启动方式采用Dockercompose
- 应用持久化目录:/home/data/bookstack/config
- mysql持久化目录:/home/data/bookstack/db
- 映射访问端口:80
- 具体启动脚本如下:
```yaml
version: "2"
services:
  bookstack_db:
    image: mysql:5.7.30
    container_name: bookstack_db
    environment:
        - PUID=1000
        - PGID=1000
        - MYSQL_ROOT_PASSWORD=icecream@2020
        - MYSQL_DATABASE=bookstack
        - MYSQL_USER=icecream
        - MYSQL_PASSWORD=icecream@2020
    volumes:
        - /home/data/bookstack/db:/var/lib/mysql
    ports:
      - 3307:3306
    restart: unless-stopped

  bookstack:
    image: bookstack:1.0.0
    container_name: bookstack
    environment:
      - PUID=1000
      - PGID=1000
      - DB_HOST=bookstack_db
      - DB_DATABASE=bookstack
      - DB_USERNAME=icecream
      - DB_PASSWORD=icecream@2020
      # Mail Setting
      - MAIL_DRIVER=smtp
      - MAIL_FROM=icecream@qq.com
      - MAIL_FROM_NAME="BookStack"
      # SMTP mail options
      - MAIL_HOST=smtp.exmail.qq.com
      - MAIL_PORT=465
      - MAIL_USERNAME=icecream@qq.com
      - MAIL_PASSWORD=icecream
      - MAIL_ENCRYPTION=ssl
      - APP_AUTO_LANG_PUBLIC=false
      # pdf渲染
      - WKHTMLTOPDF=/usr/bin/wkhtmltopdf
      # 存储为本地模式
      - STORAGE_TYPE=local
      # 默认语言为简体中文
      - APP_LANG=zh_CN
    volumes:
      - /home/data/bookstack/config:/config
    ports:
      - 80:80
    restart: unless-stopped
    depends_on:
      - bookstack_db
```

- 执行启动命令
```bash
docker-compose -f docker-compose.yaml up -d
```

- 初始超管账户:admin@admin.com  密码: password

- 应用停止命令
```bash
docker-compose -f docker-compose.yaml down
```
