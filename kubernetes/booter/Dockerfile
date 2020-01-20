FROM ubuntu:18.04
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install git -y
RUN apt-get install curl -y
RUN apt-get install software-properties-common -y
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install nodejs -y
RUN git clone https://github.com/pabloi09/quiz_2020
RUN mkdir /mnt/nas
WORKDIR /quiz_2020
RUN mkdir -p public/uploads 
RUN npm install
RUN npm install forever 
RUN npm install mysql2
RUN apt -y install mariadb-client 
ENV QUIZ_OPEN_REGISTER=yes 
ENV DATABASE_URL="mysql://quiz:xxxx@mariadb:3306/quiz"

CMD sleep 60 && \
    mysql -h mariadb -u root --password='xxxx' -e "SET SESSION sql_mode = TRIM(BOTH ',' FROM REPLACE(@@SESSION.sql_mode, 'STRICT_TRANS_TABLES', ''));" && \
    mysql -h mariadb -u root --password='xxxx' -e "SET GLOBAL sql_mode = TRIM(BOTH ',' FROM REPLACE(@@GLOBAL.sql_mode, 'STRICT_TRANS_TABLES', ''));" && \
    mysql -h mariadb -u root --password='xxxx' -e "GRANT ALL PRIVILEGES ON quiz.* to 'quiz'@'localhost' IDENTIFIED by 'xxxx';"   && \
    mysql -h mariadb -u root --password='xxxx' -e "GRANT ALL PRIVILEGES ON quiz.* to 'quiz'@'%' IDENTIFIED by 'xxxx';" && \
    mysql -h mariadb -u root --password='xxxx' -e "FLUSH PRIVILEGES;" && \
    npm run-script migrate_cdps && \
    npm run-script seed_cdps 