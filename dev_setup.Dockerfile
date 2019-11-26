FROM codercom/code-server
USER root
VOLUME /root
WORKDIR /root

RUN apt update && \
    apt -y install sudo && \
    apt -y install git nodejs npm yarn wget 
    
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.7 \
    python3-pip \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN rm /usr/bin/python && sudo ln -s /usr/bin/python3 /usr/bin/python && \
    sudo ln -s /usr/bin/pip3 /usr/bin/pip && \
    sudo apt-mark hold python python-pip

RUN pip install pandas matplotlib flask flasgger

EXPOSE 80 443 22 4200 8787 8080 
