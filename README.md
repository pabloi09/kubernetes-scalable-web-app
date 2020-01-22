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
<p align="center">
<img src="https://github.com/pabloi09/kubernetes-scalable-web-app/blob/master/images/diagramgen2.png?raw=true" height = 400 width=722/>
</p>

We had a lot of problems deploying glusterfs, so we decided to change the storage tech to NFS. The idea is to have a Google Persistent Storage, which is by definition dsitributed, as the base of the storage.To have multiple pods attacking this storage, we need intermediate layers, because this kind of storage only allows one R/W agent.

<p align="center">
<img src="https://github.com/pabloi09/kubernetes-scalable-web-app/blob/master/images/storage.png?raw=true" height = 400 width=475 />
</p>

We connect an NFS persistent volume pod to this one. Once we have this layer, we can connect as many nfs replicas to this service as we want. 

Other problem was with intial mysql migrations. With docker we had one of the three webserver container images that was responsible of making this configuration. If we wanted to have pure stateless replicable pods, we needed to make this configuration in other place. So we used <a href="https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/">Kubernetes Jobs</a>. 

Using MariaDB, made it difficult to create a master-slaves configuration. By the way, we found a built architecture downloadable with helm: https://github.com/helm/charts/tree/master/stable/mariadb .You just need to configure in values-production.yaml the database parameters and the slave replicas you want. 

<p align="center">
<img src="https://github.com/pabloi09/kubernetes-scalable-web-app/blob/master/images/bbdd.png?raw=true" height = 400 width=618/>
</p>

Nevertheless, we needed to change <a href="https://github.com/CORE-UPM/quiz_2020">the original web server app from our teachers </a> to make it work. That's the reason of downloading this web app from: https://github.com/pabloi09/quiz_2020

We also added centralized logging with ELK and the help of fluentd to connect with kubernetes. We followed <a href="https://www.nicktriller.com/blog/centralized-logging-on-kubernets-with-fluentd-elasticsearch-and-kibana/">this post</a> and we haven't changed the original configuration of it. We include the script to port-foward and access kibana.

Finally, we have deployed a monitoring infrastructure with <a href="https://github.com/helm/charts/tree/master/stable/prometheus-operator">prometheus operator</a>. It is deployed in other namespace named "monitoring". We also include the script to port-foward and access grafana and prometheus. The user and password for grafana are: admin and prom-operator.

# Try it

To try it, open your google cloud console. Then, open the shell and select your project with
```
gcloud config set project <project-id>

```
After that clone this project and get into de directory
```
git clone https://github.com/pabloi09/kubernetes-scalable-web-app
cd kubernetes-scalable-web-app/kubernetes/

```
Make the scripts executables
```
chmod + x run
chmod + x apply
chmod + x grafana
chmod + x kibana
chmod + x prometheus
chmod + x createClusterGKE
```
Create the GKE cluster and initiate the environment
```
./createClusterGKE
./run
```
To access the web page, get the external ip of the webservice
```
kubectl get services
```
To access kibana, grafana, etc, execute the script of each application and get into the preview. For example:
```
./grafana
```
<p align="center">
<img src="https://github.com/pabloi09/kubernetes-scalable-web-app/blob/master/images/shell.png?raw=true" height = 400 width=822/>
</p>
