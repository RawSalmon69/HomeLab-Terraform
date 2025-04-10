#!/bin/bash
# deploy-homer.sh - Deploy Homer dashboard

set -e

echo "============================================================"
echo "  Deploying Homer Dashboard for DevOps Homelab"
echo "============================================================"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed"
    exit 1
fi

echo "Creating homer namespace..."
kubectl create namespace homer --dry-run=client -o yaml | kubectl apply -f -

echo "Applying ConfigMap..."
kubectl apply -f homer-configmap.yaml

echo "Deploying Homer..."
kubectl apply -f homer-deployment.yaml

echo "Creating Ingress..."
kubectl apply -f homer-ingress.yaml

echo "Waiting for Homer deployment to be ready..."
kubectl rollout status deployment homer -n homer --timeout=60s

echo "============================================================"
echo "  Homer dashboard deployed successfully!"
echo "============================================================"
echo "Dashboard URL: http://localhost:3005"
echo
echo "You can now set up your own tunneling to expose this service externally."
echo "============================================================"

# Get the assigned NodePort for verification
NODE_PORT=$(kubectl get svc homer -n homer -o jsonpath='{.spec.ports[0].nodePort}')
echo "For direct NodePort access: http://your-node-ip:$NODE_PORT"
echo "============================================================"