#!/bin/bash
# Apply the updated deployment and config
kubectl apply -f tunnel-config.yaml
kubectl apply -f tunnel-deployment.yaml

# Wait for the deployment to roll out
kubectl rollout status deployment/cloudflared -n cloudflared

# Get detailed logs
echo "Getting detailed logs..."
kubectl logs -f deployment/cloudflared -n cloudflared

# If the logs show the tunnel is connecting but service is unreachable,
# then we can try adding the actual service back to the config