FROM codercom/code-server
USER root
VOLUME /root
WORKDIR /root

RUN apt update && \
    apt -y install sudo && \
    apt -y install git nodejs npm yarn wget 

RUN sudo apt-get update && \
    sudo apt install -y software-properties-common && \
    sudo add-apt-repository ppa:deadsnakes/ppa && \
    sudo apt install -y python3 && \
    rm /usr/bin/python && \
    sudo ln -s /usr/bin/python3 /usr/bin/python && \
    sudo apt install -y python3-pip && \
    sudo ln -s /usr/bin/pip3 /usr/bin/pip && \
    sudo apt-mark hold python python-pip

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80 443 22 4200 8787 8080 
