#!/bin/bash

##########################################################
## Author: Yauheni Bryshten
##
## This script create kubernetes cluster on AWS with
## 1 master and 1 worker t3.medium EC2 instances.
## Then it deploys to Services and expose it to the
## world using LoadBalancer.
##
## Prerequisites: Before the script, install kubectl and
## KOPS.
## Also configure AWS cli, create s3 bucket and add
## required policies to your IAM user: AmazonEC2FullAccess,
## AmazonS3FullAccess, IAMFullAccess, AmazonVPCFullAccess,
## AmazonSQSFullAccess, AmazonEventBridgeFullAccess. 
## 
## Use this script with 2 parameters: 1st - ClusterName, 
## 2nd - your s3 bucket (`./deploy.sh NAME KOPS_STATE_STORE`)  
##
## !!!The execution can take more then 10 minutes because of
## cluster validation. Be patient:)
##########################################################

# set -e # exit the script when error

if (($# != 2)); then
    echo "Wrong number of arguments"
    exit 1
fi


export NAME=$1
export KOPS_STATE_STORE=$2

# Create and validate kubernetes cluster
kops create cluster \
--name ${NAME} \
--state=${KOPS_STATE_STORE} \
--zones=eu-central-1a \
--node-count=1 \
--node-size=t3.medium \
--control-plane-size=t3.medium \
--control-plane-volume-size=30 \
--node-volume-size=30 \
--yes

kops validate cluster --wait 15m

# Apply nginx deployment and service
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml

# Apply django deployment and service
kubectl apply -f django-app-deploy.yaml
kubectl apply -f django-app-service.yaml

# Add helm repo to deploy ingress controller later
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -rf get_helm.sh

# Add traefik ingress repo
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik

# Apply path based ingress
kubectl apply -f ingress.yaml

echo "Script finished"




