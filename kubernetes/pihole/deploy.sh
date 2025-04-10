#!/bin/bash
# Pi-hole deployment script
set -e

echo "-------------------------------------------"
echo "  Deploying Pi-hole to Kubernetes Cluster"
echo "-------------------------------------------"

# Clean up any previous deployments
echo "Cleaning up any existing resources..."
kubectl delete namespace networking --ignore-not-found
sleep 3

# Apply all resources in the correct order
echo "Creating namespace..."
kubectl apply -f namespace.yaml
sleep 2

echo "Applying configuration..."
kubectl apply -f configmap.yaml
sleep 2

echo "Creating deployment..."
kubectl apply -f deployment.yaml
sleep 2

echo "Creating services..."
kubectl apply -f services.yaml
sleep 2

echo "Creating ingress..."
kubectl apply -f ingress.yaml
sleep 2

echo "Waiting for Pi-hole deployment to be ready..."
kubectl rollout status deployment/pihole -n networking --timeout=180s

# Get the LoadBalancer IP for DNS
PIHOLE_IP=$(kubectl get svc pihole-dns -n networking -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -n "$PIHOLE_IP" ]; then
  echo "-------------------------------------------"
  echo "  Pi-hole Deployment Complete!"
  echo "-------------------------------------------"
  echo "Pi-hole DNS service is available at: $PIHOLE_IP"
  echo "Pi-hole web interface is available at: http://$PIHOLE_IP/admin"
  echo "Login with password: pihole (you should change this)"
  
  echo ""
  echo "To configure your devices to use Pi-hole:"
  echo "1. Set DNS server to: $PIHOLE_IP"
  echo "2. Or configure your router to use $PIHOLE_IP as its DNS server"
  
  echo ""
  echo "For Tailscale remote access, run:"
  echo "sudo tailscale up --advertise-routes=$PIHOLE_IP/32 --accept-dns=false"
else
  echo "Could not find LoadBalancer IP. Check service status:"
  kubectl get svc -n networking
fi