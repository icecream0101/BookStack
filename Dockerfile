
# 官方镜像v0.29.3
FROM linuxserver/bookstack:v0.29.3-ls93

MAINTAINER icecream@qq.com

# 安装字体:微软雅黑
RUN mkdir -p /usr/share/fonts/chinese/TrueType/ 
COPY msyh.ttf /usr/share/fonts/chinese/TrueType/