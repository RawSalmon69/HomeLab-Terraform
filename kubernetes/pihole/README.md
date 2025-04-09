# Pi-hole Network-Wide Ad Blocking

This directory contains Kubernetes manifests to deploy Pi-hole in your K3s cluster, providing network-wide ad blocking functionality.

## Prerequisites

- Running K3s cluster
- kubectl configured to talk to your cluster
- Persistent storage support in your cluster

## Getting Started

1. Make the scripts executable:
   ```bash
   chmod +x deploy.sh tailscale.sh
   ```

2. Review and update the configuration files:
   - Update the timezone in `configmap.yaml`
   - Set a secure password in `secret.yaml`
   - Adjust the ingress host in `ingress.yaml`

3. Deploy Pi-hole:
   ```bash
   ./deploy.sh
   ```

4. Configure Tailscale (optional):
   ```bash
   ./tailscale.sh
   ```

## Files

- `namespace.yaml` - Creates the networking namespace
- `configmap.yaml` - Pi-hole configuration
- `secret.yaml` - Contains the web admin password
- `pvc.yaml` - Persistent volume claims for Pi-hole data
- `deployment.yaml` - Pi-hole deployment specification
- `services.yaml` - Services to expose Pi-hole DNS and web interface
- `ingress.yaml` - Ingress for accessing web interface
- `deploy.sh` - Deployment script
- `tailscale.sh` - Script to configure Tailscale for remote ad blocking

## Using Pi-hole

- Web interface: Access via the LoadBalancer IP or Ingress hostname
- Configure your router to use Pi-hole as the DNS server
- For remote usage, configure Tailscale to use Pi-hole as DNS

## Ad Blocking Everywhere

With Tailscale configured, you can enjoy ad-free browsing on all your devices, even when on mobile data or other networks.
