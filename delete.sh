#!/bin/bash

sudo kubectl delete -f ./kubernetes/spark-master-deployment.yaml
sudo kubectl delete -f ./kubernetes/spark-master-service.yaml
sudo kubectl delete -f ./kubernetes/spark-worker-deployment.yaml
