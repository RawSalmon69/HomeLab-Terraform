# DevOps Resume Homelab: Infrastructure as Code

## Project Overview

This homelab represents a comprehensive DevOps environment designed to demonstrate enterprise-grade infrastructure management, monitoring, and deployment capabilities. Built on a Ryzen 5800H laptop with 16GB RAM, the project focuses on creating a scalable, observable, and efficient infrastructure platform.

## Architecture Overview

### Infrastructure Components
- **Virtualization Platform**: Proxmox VE
- **Kubernetes Cluster**: K3s (Lightweight Kubernetes)
- **Monitoring Stack**: Prometheus and Grafana
- **Networking**: Tailscale for secure remote access

## Technical Specifications

### Virtualization Layer
- **Platform**: Proxmox Virtual Environment
- **Host Hardware**: Ryzen 5800H, 16GB RAM
- **Virtualization Strategy**: Lightweight, resource-efficient VM provisioning

### Kubernetes Cluster Configuration
- **Cluster Type**: K3s (Single master, 2 worker nodes)
- **Deployment Method**: Terraform-managed infrastructure
- **Node Specifications**:
  - Master Node: 2 vCPUs, 4GB RAM
  - Worker Nodes: 2 vCPUs, 4GB RAM each

### Monitoring Architecture
- **Metrics Collection**: Prometheus
- **Visualization**: Grafana
- **Monitoring Scope**:
  - Cluster-level metrics
  - Service-level performance tracking
  - Container resource utilization

## Implementation Phases

### Phase 1: Infrastructure Provisioning
- Terraform configuration for Proxmox VM creation
- Static IP configuration
- Cloud-init based VM deployment
- K3s cluster installation and configuration

### Phase 2: Monitoring Implementation
- Prometheus stack deployment
- Custom Grafana dashboards
- Basic alerting configuration
- Metrics persistence setup

### Phase 3: Application Deployment
- Portfolio website containerization
- Kubernetes deployment configurations
- Ingress controller setup
- Service exposure and monitoring integration

## Key Technologies

### Infrastructure as Code
- Terraform
- Proxmox Provider
- Cloud-init

### Containerization and Orchestration
- Docker
- K3s
- Kubernetes manifests

### Monitoring and Observability
- Prometheus
- Grafana
- cAdvisor
- Metrics Server

## Architectural Constraints and Design Decisions

### Intentionally Excluded Components
- Complex CI/CD pipelines
- Multi-environment setups
- Advanced security tools
- Elaborate networking policies
- Canary deployment strategies

## Strategic Objectives

1. Demonstrate practical DevOps skills
2. Create a monitorable, scalable platform
3. Showcase infrastructure management capabilities
4. Provide a flexible, extensible environment

## Deployment Workflow

1. Infrastructure Provisioning
   - Use Terraform to create Proxmox VMs
   - Apply cloud-init configurations
   - Set up static networking

2. Kubernetes Cluster Setup
   - Install K3s using k3sup
   - Configure master and worker nodes
   - Validate cluster functionality

3. Monitoring Stack Deployment
   - Install Prometheus using Helm
   - Configure Grafana dashboards
   - Set up basic alerting mechanisms

## Performance Considerations

- Minimal resource utilization
- Efficient compute allocation
- Lightweight kubernetes distribution
- Focused monitoring with low overhead

## Future Expansion Potential

- Additional service deployments
- Enhanced monitoring capabilities
- Incremental infrastructure complexity

## Repository Structure

```
.
├── terraform/                  # Infrastructure as Code
│   ├── modules/
│   │   └── k3s-cluster/
│   ├── variables.tf
│   └── main.tf
├── kubernetes/                 # Kubernetes Manifests
│   ├── monitoring/
│   └── ingress/
├── scripts/                    # Deployment and Setup Scripts
└── README.md
```