#!/bin/bash
topics=("msg_to_mongo" "ws2ms_chat" "ms2ps_chat" "msg_to_modify")
for topic in "${topics[@]}"
do
    echo "create topic $topic"
    # Replace underscore with hyphen in the topic name for pod_name
    pod_name="bitnami-kafka-client-$(echo "$topic" | tr '_' '-')"
    kubectl run "$pod_name" --restart='Never' --image docker.io/bitnami/kafka:3.4.1-debian-11-r0 --namespace kafka --command -- /opt/bitnami/kafka/bin/kafka-topics.sh \
    	--create \
    	--if-not-exists \
    	--bootstrap-server bitnami-kafka-0.bitnami-kafka-headless.kafka.svc.cluster.local:9092 \
    	--replication-factor 1 \
    	--partitions 12 \
    	--topic "$topic"
done
