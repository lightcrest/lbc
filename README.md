Load Balancer Control
=====================

These tools allow for the control of a cluster of nginx and keepalived
hosts.  A cluster consists of a master, and one or more backup nodes.

Setting Up A Cluster
====================

0) Create your load balancer VMs.  Install:

- rsync
- ssh
- keepalived
- nginx
- sudo

1) Create a new git repository to hold the configuration for the cluster.

2) Create a hosts file that defines what hosts are part of the cluster:

    cat > hosts << EOF
    10.0.0.15	0
    10.0.0.16	1
    EOF

... priority is in the right column.  Order the hosts with the highest priority being the default master.

3) Copy the nginx configuration into the git repository.  Everything under ```nginx``` will be placed in ```/etc/nginx/``` on the load balancer. Note: the nginx config will be rsync'ed with a --delete option.

4) Copy the ssl configuration into the git repostory.  This will be overlayed into ```/etc/ssl```.  No files will be deleted.

5) Create a ```keepalived``` config generator, and commit it to the git repository.  A typical example would be:

    cat > gen-keepalived-conf <<EOF
    #!/bin/bash

    index=$1 ; shift
    ipaddr=$1 ; shift

    priority=$(( (index * 1) + 100 ))

    cat <<EOF
    vrrp_script check_health {
        script "/etc/lbc/is-healthy"
        interval 2
        weight 50
        rise 1
        fall 1
    }

    vrrp_instance VI_1 {
        interface eth0

        # We must not preempt if we come back up, and another node
        # is master.
        state BACKUP

        priority $priority
        virtual_router_id 51
        advert_int 1

        authentication {
            auth_type PASS
            auth_pass SOMECOMPLEXPASSWORD
        }

        virtual_ipaddress {
            10.13.0.15
        }

        track_script {
            check_health
        }

        notify "/etc/lbc/notify"
    }
    EOF

6) Specify a user in config.bash, that same user should be added to each LB instance with full sudo privileges.

7) Run ```lbc```.  You will be given the interactive control shell.

8) add each host with associated priority with the ```add-host $host $priority``` command, i.e.
   lbc> add-host 10.0.0.15 0
   lbc> add-host 10.0.0.16 1
9) For each host, run ```init-host $hostname```.

10) Run ```status``` and verify the state of the hosts in the load balancer cluster.

11) Examine the output of ```help``` for available commands.
