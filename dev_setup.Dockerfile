FROM codercom/code-server
USER root
VOLUME /root
WORKDIR /root

RUN apt update && \
    apt -y install sudo && \
    apt -y install git nodejs npm yarn wget 

RUN sudo apt-get update && \
    sudo apt install -y software-properties-common && \
    sudo add-apt-repository ppa:deadsnakes/ppa

RUN sudo apt install -y python3.7

RUN rm /usr/bin/python && \
    sudo ln -s /usr/bin/python3 /usr/bin/python

RUN sudo apt install -y python3-pip

RUN sudo ln -s /usr/bin/pip3 /usr/bin/pip 

RUN sudo apt-mark hold python python-pip

RUN pip install pandas matplotlib flask flasgger

EXPOSE 80 443 22 4200 8787 8080 
