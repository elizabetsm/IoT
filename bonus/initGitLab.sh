#!/bin/bash

#install git
apt update
apt upgrade
apt install git 

#install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh

#create name space for gitlab
kubectl create namespace gitlab

kubectl create namespace gitlab

#deploy gitlab
git clone https://gitlab.com/gitlab-org/charts/gitlab.git
cd gitlab
cp examples/values-minikube-minimum.yaml ./
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm dependency update -n gitlab
helm upgrade --install gitlab -f values-minikube-minimum.yaml . --timeout 600s --set global.hosts.domain=192.168.99.110.nip.io --set global.edition=ce --set global.hosts.externalIP=192.168.99.110 -n gitlab
kubectl -n gitlab wait --for=condition=complete --timeout=-1s job.batch/gitlab-migrations-4
kubectl -n gitlab wait --for=condition=complete --timeout=-1s job.batch/gitlab-minio-create-buckets-4
