# The initial environment
The project was originally conceived from the university course as a virtual machine practice. We decided to replicate it, first in docker and, after that, deploy a high availability version of it in Kubernetes.
<img src="https://github.com/pabloi09/kubernetes-scalable-web-app/blob/master/images/environment.png?raw=true"/>

# Docker: troubles and limitations
The main conflicts were with Docker nature. We had to exec some containers in privileged mode so some Linux features were included in the images and the gluster file system work correctly.

First of all, to configure the volume distributed in three peers we needed to wait for the slaves servers nas2 and nas3 to initiate before initiating nas1. After that, to configure gluster we need to have the gluster deamon running. This deamon is installed in the centos image we are downloading from https://github.com/gluster/gluster-containers . To do that, we write the volume configuration in /etc/rc.d/rc.local

The webservers need also a privileged status to install glusterfs client. Then, we will make these containers sleep before mounting the directories with the nas cluster so the storage servers are running.

On the other hand, docker nature makes firewall container useless. Nevertheless,it is configure to work from LAN1. For practical purposes and technical dificulties with double NAT translations, it is the load balancer port which it is exposed.

# Kubernetes architecture

After this, we decided to make the project bigger. We have translated this architecture to one of high availability in Google Kubernetes Engine.

<img src="https://github.com/pabloi09/kubernetes-scalable-web-app/blob/master/images/diagramgen2.png?raw=true"/>

We had a lot of problems deploying glusterfs, so we decided to change the storage tech to NFS. The idea is to have a Google Persistent Storage, which is by definition dsitributed, as the base of the storage.To have multiple pods attacking this storage, we need intermediate layers, because this kind of storage only allows one R/W agent. 

<img src="https://github.com/pabloi09/kubernetes-scalable-web-app/blob/master/images/storage.png?raw=true"/>

We connect an NFS persistent volume pod to this one. Once we have this layer, we can connect as many nfs replicas to this service as we want. 

Other problem was with intial mysql migrations. With docker we had one of the three webserver container images that was responsible of making this configuration. If we wanted to have pure stateless replicable pods, we needed to make this configuration in other place. So we used <a href="https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/">Kubernetes Jobs</a>. 

Using MariaDB, made it difficult to create a master-slaves configuration. By the way, we found a built architecture downloadable with helm: https://github.com/helm/charts/tree/master/stable/mariadb .You just need to configure in values-production.yaml the database parameters and the slave replicas you want. 

<img src="https://github.com/pabloi09/kubernetes-scalable-web-app/blob/master/images/bbdd.png?raw=true"/>

Nevertheless, we needed to change <a href="https://github.com/CORE-UPM/quiz_2020">the original web server app from our teachers </a> to make it work. That's the reason of downloading this web app from: https://github.com/pabloi09/quiz_2020


