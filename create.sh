#!/bin/bash


sudo kubectl create -f ./kubernetes/spark-master-deployment.yaml
sudo kubectl create -f ./kubernetes/spark-master-service.yaml

sleep 30

sudo kubectl create -f ./kubernetes/spark-worker-deployment.yaml
