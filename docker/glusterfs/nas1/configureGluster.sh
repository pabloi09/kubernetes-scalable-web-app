#!/bin/bash
gluster peer probe 20.20.4.21 
gluster peer probe 20.20.4.22  
gluster peer probe 20.20.4.23 
gluster volume create nas replica 3 20.20.4.21:/nas 20.20.4.22:/nas 20.20.4.23:/nas force 
gluster volume start nas 
gluster volume set nas network.ping-timeout 5 