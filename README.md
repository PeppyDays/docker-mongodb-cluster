# MongoDB Cluster Docker Compose

This repository have MongoDB cluster docker compose file and configuration files to easily set for education purpose.

## Prerequisite

At first you should install docker and docker-compose in any linux OS. You can find installation guide for [docker](https://docs.docker.com/engine/installation/linux/docker-ce/centos/) and [docker-compose](https://docs.docker.com/compose/install/).

## Cluster Structure

This docker-compose file has 2 shard replica sets, 1 config replica set and 1 mongos router. Shard replica set has 1 primary, 1 secondary and 1 arbiter containers. And config replica set has 1 primary and 2 secondary containers. Here is total 10 containers.

Each replica set is composed of shard name and host name like below.

host names in **kakao01** shard replica set
: kakao01-primary, kakao01-secondary, kakao01-arbiter

host names in **kakao02** shard replica set
: kakao02-primary, kakao02-secondary, kakao02-arbiter

host names in **config** config replica set
: config-primary, config-secondary, config-tertiary

host name of **mongos** router
: mongos

## Port, Configuration File and Data Directory

All of containers has mount point with `/data/db` and this is connected to `./data/{shard name}/{postfix of host name}` in host machine. For example, `/data/db` in the kakao01-primary container is connected to `./data/kakao01/primary` of host machine.

And in the `./conf` directory of host machine, there are configuration files to run mongod and mongos process. Files are divided by shard and containers in the same shard use same configuration files.

And all the processes' service port in the container is 27071. But in the host machine need total 10 ports to map to 10 containers. You can check this port mapping in the docker-compose file.

## Startup containers

You may want to daemonize running containers with docker-compose, so you need to prepare 2 sessions to host machine. I named those to Session 1 and Session 2.

At first you should run `docker-compose up` to run containers and mongod processes.

```bash
# Session 1, clear data and run docker-compose and check logs
$ ./reset.sh
$ docker-compose up -d
$ docker-compose logs -f
```

And initiate 3 replica sets and add secondary instances to primary instance.

```bash
# Session 2, initiate replica sets and shard cluster
$ ./replica_initiate.sh
$ ./replica_status.sh
```

You can countinuously check status of each replica set with replica_status.sh script. After running all replica sets normaly, you should configure cluster like below.

```bash
# Session 2, check status of replica sets and shard cluster
$ ./shard_initiate.sh
$ ./shard_status.sh
```

if standard output of `shard_status.sh` result like below, you success!

```bash
Status in cluster ===============================================
MongoDB shell version v3.4.9
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.9
--- Sharding Status ---
  sharding version: {
    "_id" : 1,
    "minCompatibleVersion" : 5,
    "currentVersion" : 6,
    "clusterId" : ObjectId("59eb3f0fb4af3a3d9a23f8aa")
}
  shards:
    {  "_id" : "kakao01",  "host" : "kakao01/kakao01-primary:27017,kakao01-secondary:27017",  "state" : 1 }
    {  "_id" : "kakao02",  "host" : "kakao02/kakao02-primary:27017,kakao02-secondary:27017",  "state" : 1 }
  active mongoses:
    "3.4.9" : 1
 autosplit:
    Currently enabled: yes
  balancer:
    Currently enabled:  yes
    Currently running:  yes
        Balancer lock taken at Mon Oct 23 2017 16:11:09 GMT+0000 (UTC) by ConfigServer:Balancer
    Failed balancer rounds in last 5 attempts:  0
    Migration Results for the last 24 hours:
        No recent migrations
  databases:
    {  "_id" : "kakao",  "primary" : "kakao02",  "partitioned" : false }

bye
=================================================================
```

## Reset data files

If you want to clear all data, you just run `reset.sh` script. This script will delete all files in `./data` and make directories mongod needs.
