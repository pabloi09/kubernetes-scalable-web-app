FROM gluster/gluster-centos
COPY ./configureGluster.sh /
RUN chmod +x ./configureGluster.sh
RUN chmod +x /etc/rc.d/rc.local
RUN echo -e "./configureGluster.sh\n" >> /etc/rc.d/rc.local




