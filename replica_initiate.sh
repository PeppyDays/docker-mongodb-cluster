#!/bin/bash

shards=( kakao01 kakao02 )

for shard in ${shards[@]}; do
  echo "Initialize $shard primary"
  docker exec $shard-primary bash -c "echo \"rs.initiate();\" | mongo"

  sleep 1

  echo ""
  echo "Add $shard secondary and arbiter to replica set"
  docker exec $shard-primary bash -c "echo \"rs.add('$shard-secondary:27017');\" | mongo"
  docker exec $shard-primary bash -c "echo \"rs.addArb('$shard-arbiter:27017');\" | mongo"
done

shard="config"

echo "Initialize $shard primary"
docker exec $shard-primary bash -c "echo \"rs.initiate();\" | mongo"

sleep 1

echo ""
echo "Add $shard secondaries to replica set"
docker exec $shard-primary bash -c "echo \"rs.add('$shard-secondary:27017');\" | mongo"
docker exec $shard-primary bash -c "echo \"rs.add('$shard-tertiary:27017');\" | mongo"

