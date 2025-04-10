#!/bin/bash
# Get Pi-hole DNS IP
PIHOLE_IP=$(kubectl get svc pihole-dns -n networking -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$PIHOLE_IP" ]; then
  echo "Error: No LoadBalancer IP found for Pi-hole"
  exit 1
fi

echo "Found Pi-hole DNS IP: $PIHOLE_IP"
echo "Setting up Tailscale to advertise Pi-hole..."
sudo tailscale up --advertise-routes=$PIHOLE_IP/32 --accept-dns=false

echo "Next steps:"
echo "1. Go to Tailscale admin console: https://login.tailscale.com/admin"
echo "2. Enable subnet routes for this node"
echo "3. Configure DNS settings to use Pi-hole"