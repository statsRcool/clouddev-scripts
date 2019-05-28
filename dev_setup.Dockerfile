FROM codercom/code-server
USER root
VOLUME /root
WORKDIR /root

RUN apt update && \
    apt -y install sudo && \
    apt -y install git nodejs npm yarn wget 

EXPOSE 80 443 22 4200 8787 8080 
