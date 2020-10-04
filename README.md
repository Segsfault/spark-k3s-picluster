# spark-k3s-picluster
Running Apache Spark on Kubernetes using a cluster of Raspberry PI 3B+.  Because we can.

This assumes you have a raspberry pi cluster running k3s up and running.  You can reference 
[this repo](https://github.com/Segsfault/ansible-k3s-picluster) for guidance on how to do that.

## Cluster Setup
These instructions are based on the following configuration:
1. Cluster can support at least 2 worker nodes
2. k3s commands are executed from the master node.
3. access to the spark ui will be from outside the k3s cluster.

One could run these commands (minus the sudo) from a local machine that remotely manages the k3s cluster as well.

The container images are setup in such a way that they can act as workers or master nodes depending on the commands
passed in the deployment files.  A [prebuilt image](https://hub.docker.com/repository/docker/segsfault/pi-spark3) is ready to go from Dockerhub, but substitute your own if you like.


## Spinning up the spark nodes
First, we need to create a namespace to segment our spark cluster from the rest of the Kubernetes environment

    sudo kubectl create namespace spark-cluster

Next, run the `create.sh` script.  It will first create the master pod and service (which will expose the ports we need to operate and access spark), then it will create the worker pods.

After a couple of minutes, you can check the status by running

    sudo kubectl get ingress,svc,pods -n spark-cluster

You should see something like the following:

    NAME                               CLASS    HOSTS   ADDRESS       PORTS   AGE
    ingress.extensions/spark-ingress   <none>   *       10.10.1.104   80      17h

    NAME                          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
    service/spark-master-node     ClusterIP   10.43.136.64   <none>        7077/TCP   17h
    service/spark-webui-service   ClusterIP   10.43.45.225   <none>        8080/TCP   17h

    NAME                                     READY   STATUS    RESTARTS   AGE
    pod/spark-master-node-bf4874f97-bwtfr    1/1     Running   0          17h
    pod/spark-worker-node-587d6979bf-wg4hv   1/1     Running   0          17h
    pod/spark-worker-node-587d6979bf-44zg6   1/1     Running   0          17h


The `ADDRESS` in the ingress section is how you can access the UI.  Plug it into a web browser and you should see the spark UI and check to see that it sees all the worker nodes (2 based on the ReplicaSet in the k3s deployment yaml.)  


![Spark UI](https://github.com/Segsfault/spark-k3s-picluster/Spark-Pi.png)


## Tearing it down
Just run the `delete.sh` script to spin the cluster down.


### Reference posts
https://github.com/testdrivenio/spark-kubernetes
https://towardsdatascience.com/a-journey-into-big-data-with-apache-spark-part-1-5dfcc2bccdd2
https://dev.to/fransafu/the-first-experience-with-k3s-lightweight-kubernetes-deploy-your-first-app-44ea
https://github.com/helm/charts/tree/master/stable/spark
