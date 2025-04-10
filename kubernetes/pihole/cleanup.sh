#!/bin/bash
# Cleanup script for Pi-hole deployment

echo "Cleaning up Pi-hole resources..."

# Delete all Pi-hole related resources
kubectl delete ingress -n networking pihole-ingress --ignore-not-found
kubectl delete service -n networking pihole-dns pihole-web --ignore-not-found
kubectl delete deployment -n networking pihole --ignore-not-found
kubectl delete configmap -n networking pihole-config --ignore-not-found
kubectl delete namespace networking --ignore-not-found

echo "Checking for any remaining resources..."
kubectl get all -n networking --ignore-not-found

echo "Cleanup complete."