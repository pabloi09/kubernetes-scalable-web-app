FROM haproxy:1.7
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
RUN apt-get update
RUN apt-get install net-tools -y
RUN apt-get install curl -y
RUN apt-get install iputils-ping -y