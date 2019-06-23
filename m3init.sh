curl -X POST localhost:7201/api/v1/placement/init -d '{
    "num_shards": 4,
    "replication_factor": 3,
    "instances": [
        {
            "id": "master",
            "isolation_group": "us-east1-a",
            "zone": "embedded",
            "weight": 100,
            "endpoint": "192.168.2.104:9000",
            "hostname": "master",
            "port": 9000
        },
        {
            "id": "node1",
            "isolation_group": "us-east1-b",
            "zone": "embedded",
            "weight": 100,
            "endpoint": "192.168.2.102:9000",
            "hostname": "node1",
            "port": 9000
        },
        {
            "id": "node2",
            "isolation_group": "us-east1-c",
            "zone": "embedded",
            "weight": 100,
            "endpoint": "192.168.2.103:9000",
            "hostname": "node2",
            "port": 9000
        }
    ]
}'
