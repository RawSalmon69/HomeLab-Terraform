#!/bin/bash
# deploy-monitoring.sh - Script to deploy Prometheus monitoring stack to K3s cluster

set -e

echo "============================================================"
echo "  Deploying Prometheus Monitoring Stack for K3s"
echo "============================================================"

if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed"
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo "Error: helm is not installed"
    exit 1
fi

echo "Checking cluster connection..."
kubectl get nodes &> /dev/null || { echo "Error: Cannot connect to Kubernetes cluster"; exit 1; }

echo "Adding Prometheus Helm repository..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "Creating monitoring namespace..."
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "Installing kube-prometheus-stack..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values kubernetes/monitoring/prometheus-values.yaml \
  --wait --timeout 10m

echo "Creating Grafana ingress..."
kubectl apply -f kubernetes/monitoring/grafana-ingress.yaml

echo "Waiting for Grafana deployment to be ready..."
kubectl rollout status deployment -n monitoring prometheus-grafana --timeout=300s

GRAFANA_PASSWORD=$(kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)

echo "============================================================"
echo "  Monitoring stack deployed successfully!"
echo "============================================================"
echo "Grafana URL: http://grafana.rawsalmon.internal"
echo "Username: admin"
echo "Password: ${GRAFANA_PASSWORD}"
echo 
echo "Don't forget to add this entry to your hosts file:"
echo "192.168.1.50  grafana.rawsalmon.internal"
echo "============================================================"