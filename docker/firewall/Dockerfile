FROM ubuntu:18.04
COPY ./fw.fwb /
COPY ./fw.fw /
RUN apt-get update
RUN apt-get install fwbuilder -y
ENV QT_X11_NO_MITSHM=1
RUN apt-get install iptables -y
RUN apt-get install kmod -y
RUN apt-get install iproute2 -y 
RUN apt-get install net-tools -y
RUN apt-get install curl -y



CMD ./fw.fw && \
    while true; do echo me quedo encendida;	sleep 1000000; done