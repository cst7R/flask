#
# 选择基础镜像。如需更换，请到[dockerhub官方仓库](https://hub.docker.com/_/python?tab=tags)自行选择后替换。
FROM ubuntu:20.04

# 更新软件包列表并安装ca-certificates
# 更新 apt-get 源和安装 ca-certificates 包
RUN apt-get update && apt-get install -y ca-certificates \
# 更新证书
&& update-ca-certificates

RUN sed -i 's#http://archive.ubuntu.com/#http://mirrors.tuna.tsinghua.edu.cn/#' /etc/apt/sources.list \
&& apt-get clean

# 更新软件包列表并安装Python3和pip
RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip \
&& rm -rf /var/lib/apt/lists/*

# 拷贝当前项目到/app目录下（.dockerignore中文件除外）
COPY . /app

# 设定当前的工作目录
WORKDIR /app

RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
&& pip3 config set install.trusted-host pypi.tuna.tsinghua.edu.cn \
&& pip3 install pip -U \
# 安装依赖包
&& pip3 install -r requirements.txt

# 暴露端口
# 此处端口必须与「服务设置」-「流水线」以及「手动上传代码包」部署时填写的端口一致，否则会部署失败。
EXPOSE 80

# 执行启动命令
CMD ["python3", "run.py", "0.0.0.0", "80"]