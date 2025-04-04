#!/bin/bash
# install-monitoring.sh - Script to install a lightweight Prometheus and Grafana stack for a homelab

set -e

echo "Creating monitoring namespace..."
kubectl create namespace monitoring 2>/dev/null || echo "Namespace already exists"

echo "Adding and updating Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "Creating Prometheus values file..."
cat > prometheus-minimal.yaml << 'EOF'
server:
  retention: 1d
  scrape_interval: 1s
  evaluation_interval: 1s
  resources:
    limits:
      memory: 1Gi
      cpu: 500m
    requests:
      memory: 256Mi
      cpu: 100m
  persistentVolume:
    enabled: false
alertmanager:
  enabled: false
EOF

echo "Creating Grafana values file..."
cat > grafana-values.yaml << 'EOF'
adminPassword: admin
persistence:
  enabled: true
  size: 1Gi
resources:
  limits:
    memory: 512Mi
    cpu: 200m
  requests:
    memory: 128Mi
    cpu: 100m
EOF

echo "Creating Grafana Prometheus datasource config..."
cat > prometheus-datasource.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-prometheus-datasource
  namespace: monitoring
data:
  prometheus-datasource.yaml: |-
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server.monitoring.svc.cluster.local
      access: proxy
      isDefault: true
EOF

echo "Installing Prometheus..."
helm install prometheus prometheus-community/prometheus -n monitoring -f prometheus-minimal.yaml

echo "Installing Grafana..."
helm install grafana grafana/grafana -n monitoring -f grafana-values.yaml

echo "Waiting for Prometheus to be ready..."
kubectl rollout status deployment prometheus-server -n monitoring

echo "Waiting for Grafana to be ready..."
kubectl rollout status deployment grafana -n monitoring

echo "Applying Prometheus datasource to Grafana..."
kubectl apply -f prometheus-datasource.yaml

# Restart Grafana to pick up the datasource
echo "Restarting Grafana to apply datasource..."
kubectl rollout restart deployment grafana -n monitoring
kubectl rollout status deployment grafana -n monitoring

echo "Grafana credentials:"
echo "  Username: admin"
echo "  Password: admin"

echo "Monitoring stack installation complete"
echo ""
echo "To access Grafana, run:"
echo "  kubectl port-forward -n monitoring svc/grafana 3000:80"
echo "Then open http://localhost:3000 in your browser"
echo ""
echo "To access Prometheus, run:"
echo "  kubectl port-forward -n monitoring svc/prometheus-server 9090:80"
echo "Then open http://localhost:9090 in your browser"