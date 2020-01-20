FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install mariadb-server  -y
RUN sed -i -e 's/bind-address.*/bind-address=0.0.0.0/' -e 's/utf8mb4/utf8/' /etc/mysql/mariadb.conf.d/50-server.cnf # continuación línea anterior
RUN service mysql restart && \
    mysqladmin -u root password xxxx && \
    mysql -u root --password='xxxx' -e "CREATE USER 'quiz' IDENTIFIED BY 'xxxx';" && \
    mysql -u root --password='xxxx' -e "CREATE DATABASE quiz;"  && \
    mysql -u root --password='xxxx' -e "GRANT ALL PRIVILEGES ON quiz.* to 'quiz'@'localhost' IDENTIFIED by 'xxxx';"  && \
    mysql -u root --password='xxxx' -e "GRANT ALL PRIVILEGES ON quiz.* to 'quiz'@'%' IDENTIFIED by 'xxxx';" && \
    mysql -u root --password='xxxx' -e "FLUSH PRIVILEGES;"  

CMD service mysql start && while	true; do echo me quedo encendida; sleep 1000000;	done
