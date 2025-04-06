In Grafana (http://localhost:3000):

Go to Configuration (gear icon) > Data sources
Click "Add data source"
Select "Prometheus"
Set URL to: http://prometheus-server.monitoring.svc.cluster.local

kubectl get cm prometheus-server -n monitoring -o yaml > prometheus-config.yaml
kubectl apply -f prometheus-config.yaml

Go to "+" > Import
Enter dashboard ID 15757 (for K3s) or 315 (for Kubernetes)
Select your Prometheus data source and click "Import"

kubectl patch svc portfolio -n portfolio-service -p '{"spec":{"type":"NodePort","ports":[{"port":80,"nodePort":30080}]}}'
kubectl get svc -n portfolio-service