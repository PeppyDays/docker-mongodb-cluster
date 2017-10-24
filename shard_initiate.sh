#!/bin/bash

shards=( kakao01 kakao02 )

for shard in ${shards[@]}; do
  echo "Add $shard to cluster"
  docker exec mongos bash -c "echo \"sh.addShard('$shard/$shard-primary:27017,$shard-secondary:27017,$shard-arbiter:27017')\" | mongo"
done
