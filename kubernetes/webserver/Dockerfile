FROM ubuntu:18.04
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install git -y
RUN apt-get install curl -y
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:gluster/glusterfs-7 -y
RUN apt install glusterfs-client -y
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install nodejs -y
RUN git clone https://github.com/pabloi09/quiz_2020
RUN mkdir /mnt/nas
RUN mknod /dev/fuse c 10 229
WORKDIR /quiz_2020
RUN mkdir -p public/uploads 
RUN npm install
RUN npm install forever 
RUN npm install mysql2
ENV QUIZ_OPEN_REGISTER=yes 
ENV DATABASE_URL="mysql://quiz:xxxx@mariadb:3306/quiz"

CMD sleep 20 && \
    ./node_modules/forever/bin/forever start ./bin/www && \
    while true; do echo me quedo encendida;	sleep 1000000; done
