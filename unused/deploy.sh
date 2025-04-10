#!/bin/bash
set -e

echo "Deploying simplified Pi-hole setup..."

# Apply all resources
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f services.yaml
kubectl apply -f ingress.yaml

echo "Waiting for Pi-hole deployment to be ready..."
kubectl rollout status deployment/pihole -n networking

# Get the LoadBalancer IP for DNS
PIHOLE_IP=$(kubectl get svc pihole-dns -n networking -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -n "$PIHOLE_IP" ]; then
  echo "Pi-hole DNS service is available at: $PIHOLE_IP"
  echo "Pi-hole web interface is available at: http://$PIHOLE_IP/admin"
  echo "Login with password: pihole (you should change this)"
  
  echo ""
  echo "To configure your devices to use Pi-hole:"
  echo "1. Set DNS server to: $PIHOLE_IP"
  echo "2. Or configure your router to use $PIHOLE_IP as its DNS server"
else
  echo "Could not find LoadBalancer IP. Check service status:"
  kubectl get svc -n networking
fi