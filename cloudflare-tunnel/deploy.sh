#!/bin/bash
# deploy.sh - Script to deploy Cloudflare Tunnel in K3s

set -e

echo "Creating cloudflared namespace..."
kubectl apply -f namespace.yaml

echo "Applying tunnel secret..."
# Instead of using sed, edit the file manually before running this script
# or use environment variables
kubectl apply -f tunnel-secret.yaml

echo "Applying tunnel config..."
# Instead of using sed, edit the file manually before running this script
kubectl apply -f tunnel-config.yaml

echo "Deploying cloudflared..."
kubectl apply -f tunnel-deployment.yaml

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/cloudflared -n cloudflared

echo "Checking pods..."
kubectl get pods -n cloudflared

echo "Checking logs of the first pod..."
POD=$(kubectl get pods -n cloudflared -o jsonpath='{.items[0].metadata.name}')
kubectl logs $POD -n cloudflared

echo "Tunnel deployment complete!"
echo "Make sure you've properly configured the DNS in Cloudflare dashboard."
echo "Your Grafana should be accessible at: https://monitor.phanthawas.dev"