#!/bin/bash

shards=( kakao01 kakao02 config )

for shard in ${shards[@]}; do
  replica=primary
  echo "Status in $replica of $shard ==========================================="
  docker exec $shard-$replica bash -c "echo \"rs.status();\" | mongo"
  echo "========================================================================"
done

