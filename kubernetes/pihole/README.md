# Pi-hole for Kubernetes

This directory contains Kubernetes manifests to deploy Pi-hole, a network-wide ad blocker.

## Features

- DNS-level ad blocking for your entire network
- Web interface for monitoring and configuration
- Works with Tailscale for remote ad blocking (optional)

## Deployment

1. Make the deployment script executable:
   ```
   chmod +x deploy.sh
   ```

2. Run the deployment script:
   ```
   ./deploy.sh
   ```

3. Access the Pi-hole web interface:
   - Via LoadBalancer IP: `http://<LOADBALANCER_IP>/admin`
   - Via Ingress (if configured): `http://pihole.local/admin`

4. Login with the default password: `pihole`
   - You should change this in `configmap.yaml` before deployment

## Configuration

Edit `configmap.yaml` to customize:
- Timezone
- Web interface password
- Upstream DNS servers

## Files

- `namespace.yaml`: Creates the networking namespace
- `configmap.yaml`: Pi-hole configuration
- `deployment.yaml`: Pi-hole deployment
- `services.yaml`: Services for DNS and web interface
- `ingress.yaml`: Ingress for accessing the web interface
- `deploy.sh`: Deployment script

## Network-Wide Setup

To use Pi-hole for your entire network, configure your router to use the Pi-hole's IP address as its primary DNS server.

## Remote Access with Tailscale

To access Pi-hole's ad blocking when away from home:

1. On your cluster node:
   ```
   sudo tailscale up --advertise-routes=<PIHOLE_IP>/32 --accept-dns=false
   ```

2. In Tailscale admin console:
   - Enable subnet routes for your node
   - Configure DNS settings to use Pi-hole