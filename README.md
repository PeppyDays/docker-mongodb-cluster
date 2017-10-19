# MongoDB Sharding Docker

`docker-compose` file and configuration files to startup MongoDB sharding cluster.

Sharding cluster consist of 10 containers like below.

`kakao01` shard replica set
: kakao01-primary, kakao01-secondary, kakao01-arbiter

`kakao02` shard replica set
: kakao02-primary, kakao02-secondary, kakao02-arbiter

`config` config replica set
: config-primary, config-secondary, config-tertiary

`mongos` router
: mongos

After composing up 10 containers, you should run scripts to initialize replica sets and shard cluster. Commands are like below.

```bash
$ ./replica_initiate.sh
$ ./shard_initiate.sh
```

To check status of replica sets and shard cluster status, run status scripts.

```bash
$ ./replica_status.sh
$ ./shard_status.sh
```

Data of MongoDB stores in the data directory. So if you want to clean all the data and start again, you should run reset command.

```bash
$ ./reset.sh
```

Finally, you can run MongoDB shard cluster like below.

```bash
# Session 1, clear data and run docker-compose and check logs
$ ./reset.sh
$ docker-compose up -d
$ docker-compose logs -f

# Session 2, initiate replica sets and shard cluster
$ ./replica_initiate.sh
$ ./shard_initiate.sh

# Session 2, check status of replica sets and shard cluster
$ ./replica_status.sh
$ ./shard_status.sh
```

And you can connect to mongos router by accessing to 27047 port of localhost.
