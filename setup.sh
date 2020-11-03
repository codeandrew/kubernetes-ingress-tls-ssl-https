#!/bin/bash
NS=app

# Install the Helm (v3) chart for nginx ingress controller
# helm install app-ingress ingress-nginx/ingress-nginx \
#      --namespace ingress \
#      --create-namespace \
#      --set controller.replicaCount=2 \
#      --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
#      --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

# kubectl get services --namespace ingress

# Requirements for acme 
kubectl label namespace cert-manager cert-manager.io/disable-validation=true

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Create Namespace
kubectl create namespace cert-manager

# Install the cert-manager Helm chart
helm install \
  cert-manager \
  --namespace cert-manager \
  --version v0.16.1 \
  --set installCRDs=true \
  --set nodeSelector."beta\.kubernetes\.io/os"=linux \
  jetstack/cert-manager

# Creating Helm Template
helm template ./chart --values ./chart/values.yaml > template.yaml

kubectl apply -f template.yaml -n $NS --validate=false