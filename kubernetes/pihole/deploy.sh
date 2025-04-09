#!/bin/bash
set -e

echo "Deploying Pi-hole to Kubernetes..."

kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f pvc.yaml
kubectl apply -f deployment.yaml
kubectl apply -f services.yaml
kubectl apply -f ingress.yaml

echo "Waiting for Pi-hole to start..."
kubectl -n networking rollout status deployment pihole

echo "Getting Pi-hole DNS IP..."
PIHOLE_IP=$(kubectl get svc pihole-dns -n networking -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$PIHOLE_IP" ]; then
  echo "No LoadBalancer IP found. If using NodePort, find your node IP and port with:"
  NODE_PORT=$(kubectl get svc pihole-dns -n networking -o jsonpath='{.spec.ports[0].nodePort}')
  echo "Pi-hole DNS available on your K3s node IPs on port $NODE_PORT"
else
  echo "Pi-hole DNS IP: $PIHOLE_IP"
  echo "To configure Tailscale, run:"
  echo "sudo tailscale up --advertise-routes=$PIHOLE_IP/32 --accept-dns=false"
fi

echo "Pi-hole web interface: http://$PIHOLE_IP/admin"
echo "Login with the password from your secret.yaml file"