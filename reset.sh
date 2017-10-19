#!/bin/bash

shards=( kakao01 kakao02 )
replicas=( primary secondary arbiter )

for shard in ${shards[@]}; do
  for replica in ${replicas[@]}; do
    echo "Reset data/$shard/$replica"
    rm -rf data/$shard/$replica
    mkdir -p data/$shard/$replica
  done
done

shard=config
replicas=( primary secondary tertiary )

for replica in ${replicas[@]}; do
  echo "Reset data/$shard/$replica"
  rm -rf data/$shard/$replica
  mkdir -p data/$shard/$replica
done

echo "Reset data/mongos"
rm -rf data/mongos
mkdir -p data/mongos
