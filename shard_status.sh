#!/bin/bash

echo "Status in cluster ==============================================="
docker exec mongos bash -c "echo \"sh.status();\" | mongo"
echo "================================================================="

