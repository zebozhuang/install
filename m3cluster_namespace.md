
namespace: default
type: unaggregated
retention: 6h
namespace: metrics_5m_24h
type: aggregated
retention: 24h
resolution: 5m
namespace: metrics_60m_15d
type: aggregated
retention: 360h
resolution: 60m
namespace: metrics_24h_712d
type: aggregated
retention: 17520h
resolution: 24h
curl -sSf -X POST localhost:7201/api/v1/placement/init -d '{
"num_shards": 16,
"replication_factor": 3,
"instances": [
{
"id": "m3dbnode-0",
"isolation_group": "pod0",
"zone": "embedded",
"weight": 100,
"endpoint": "m3dbnode-0.m3dbnode:9000",
"hostname": "m3dbnode-0.m3dbnode",
"port": 9000
},
{
"id": "m3dbnode-1",
"isolation_group": "pod1",
"zone": "embedded",
"weight": 100,
"endpoint": "m3dbnode-1.m3dbnode:9000",
"hostname": "m3dbnode-1.m3dbnode",
"port": 9000
},
{
"id": "m3dbnode-2",
"isolation_group": "pod2",
"zone": "embedded",
"weight": 100,
"endpoint": "m3dbnode-2.m3dbnode:9000",
"hostname": "m3dbnode-2.m3dbnode",
"port": 9000
}
]
}'

curl -X POST localhost:7201/api/v1/namespace -d '{
"name": "default",
"options": {
"bootstrapEnabled": true,
"flushEnabled": true,
"writesToCommitLog": true,
"cleanupEnabled": true,
"snapshotEnabled": true,
"repairEnabled": false,
"retentionOptions": {
"retentionPeriodDuration": "6h",
"blockSizeDuration": "2h",
"bufferFutureDuration": "1h",
"bufferPastDuration": "1h",
"blockDataExpiry": true,
"blockDataExpiryAfterNotAccessPeriodDuration": "5m"
},
"indexOptions": {
"enabled": true,
"blockSizeDuration": "2h"
}
}
}'

curl -X POST localhost:7201/api/v1/namespace -d '{
"name": "metrics_5m_24h",
"options": {
"bootstrapEnabled": true,
"flushEnabled": true,
"writesToCommitLog": true,
"cleanupEnabled": true,
"snapshotEnabled": true,
"repairEnabled": false,
"retentionOptions": {
"retentionPeriodDuration": "24h",
"blockSizeDuration": "6h",
"bufferFutureDuration": "1h",
"bufferPastDuration": "1h",
"blockDataExpiry": true,
"blockDataExpiryAfterNotAccessPeriodDuration": "5m"
},
"indexOptions": {
"enabled": true,
"blockSizeDuration": "6h"
}
}
}'

curl -X POST localhost:7201/api/v1/namespace -d '{
"name": "metrics_60m_15d",
"options": {
"bootstrapEnabled": true,
"flushEnabled": true,
"writesToCommitLog": true,
"cleanupEnabled": true,
"snapshotEnabled": true,
"repairEnabled": false,
"retentionOptions": {
"retentionPeriodDuration": "360h",
"blockSizeDuration": "24h",
"bufferFutureDuration": "1h",
"bufferPastDuration": "1h",
"blockDataExpiry": true,
"blockDataExpiryAfterNotAccessPeriodDuration": "5m"
},
"indexOptions": {
"enabled": true,
"blockSizeDuration": "24h"
}
}
}'

curl -X POST localhost:7201/api/v1/namespace -d '{
"name": "metrics_24h_712d",
"options": {
"bootstrapEnabled": true,
"flushEnabled": true,
"writesToCommitLog": true,
"cleanupEnabled": true,
"snapshotEnabled": true,
"repairEnabled": false,
"retentionOptions": {
"retentionPeriodDuration": "17520h",
"blockSizeDuration": "24h",
"bufferFutureDuration": "1h",
"bufferPastDuration": "1h",
"blockDataExpiry": true,
"blockDataExpiryAfterNotAccessPeriodDuration": "5m"
},
"indexOptions": {
"enabled": true,
"blockSizeDuration": "24h"
}
}
}'

prometheus remote write read from cluster
m3 cluster frequently down or oom

what's wrong?


Yoram Hekma @yhekma May 09 16:29
@DORcode 16GB?
that’s really low
ç

