# SmartLoanAI Model

## Overview

Organized Kubernetes manifests to deploy the SmartLoan AI application stack with a modular, component-based structure:

- **Backend API** (FastAPI/Uvicorn)
- **Celery Worker** (Background tasks)
- **Chatbot UI** (Streamlit frontend)
- **MariaDB** (SQL Database with full schema)
- **Valkey/Redis** (Cache & Message Broker)
- **Qdrant** (Vector Database)

## Prerequisites

1. **Kubernetes cluster** (minikube, Docker Desktop, or cloud cluster)
2. **kubectl** configured and connected
3. **Docker registry** (local or cloud)

## Quick Start

### 1. Build and Push Images
> **Note:** If you haven't built the images yet, make sure to adjust the Docker registry settings in the scripts as needed. Then, run the following command from the project root directory:

```powershell
# Build Docker images
.\deployments\scripts\build.ps1
```

### 2. Deploy All Components

```powershell
cd deployments
.\scripts\deploy.ps1
```

### 3. Access the Application

```bash
# Port forward to access API
kubectl port-forward svc/idp-api-service 8081:8081 -n smartloan-ai

# Port forward to access Chatbot UI
kubectl port-forward svc/chatbot-ui-service 8051:8051 -n smartloan-ai

# Access API at http://localhost:8081
# Access UI at http://localhost:8051
```
<!-- 
## Directory Structure

```
deployments/
├── infrastructure/          # Core infrastructure
│   ├── namespace.yaml        # Namespace definition
│   ├── configmaps.yaml       # ConfigMaps and Secrets
│   ├── volumes.yaml          # PersistentVolumes & Claims
│   ├── autoscaling.yaml      # HorizontalPodAutoscaler
│   └── network-policy.yaml   # Network security policies
├── databases/              # Database layer
│   ├── mariadb.yaml          # SQL database with init script
│   ├── valkey.yaml           # Cache/Redis database
│   └── qdrant.yaml           # Vector database
├── backend/                # Backend services
│   ├── api.yaml              # FastAPI application
│   └── worker.yaml           # Celery workers
├── frontend/               # Frontend services
│   └── chatbot-ui.yaml       # Streamlit UI with config
└── scripts/                # Deployment scripts
    ├── deploy.ps1            # Main deployment script
    ├── build.ps1             # Docker build script
    └── cleanup.ps1           # Cleanup script
```

## Configuration

### Environment Variables

Configured in `configmaps.yaml`:

- **Database connections** (MariaDB, Valkey, Qdrant)
- **API keys** (OpenAI)
- **Application settings**

### Secrets

Sensitive data in `smartloan-secrets`:

- `OPENAI_API_KEY`
- `MYSQL_ROOT_PASSWORD`
- `SECRET_KEY`

### Storage

PersistentVolumes for:

- MariaDB data (20Gi)
- Qdrant vectors (10Gi)
- Valkey cache (5Gi)

## Monitoring & Debugging

### Check Deployment Status

```bash
# All resources
kubectl get all -n smartloan-ai

# Pods status
kubectl get pods -n smartloan-ai

# Services
kubectl get svc -n smartloan-ai
```

### View Logs

```bash
# API logs
kubectl logs -f deployment/idp-api-deployment -n smartloan-ai

# Worker logs
kubectl logs -f deployment/idp-worker-deployment -n smartloan-ai

# Database logs
kubectl logs -f deployment/mariadb-deployment -n smartloan-ai
```

### Debug Pod Issues

```bash
# Describe pod
kubectl describe pod <pod-name> -n smartloan-ai

# Execute into pod
kubectl exec -it <pod-name> -n smartloan-ai -- /bin/bash

# Check pod events
kubectl get events -n smartloan-ai --sort-by='.lastTimestamp'
```

## Scaling

### Scale Applications

```bash
# Scale API
kubectl scale deployment idp-api-deployment --replicas=3 -n smartloan-ai

# Scale Workers
kubectl scale deployment idp-worker-deployment --replicas=5 -n smartloan-ai
```

### Resource Limits

Each component is configured with:

- **Requests**: Minimum resources
- **Limits**: Maximum resources
- **Probes**: Health checks

## Ingress

The API can be exposed via Ingress:

- Host: `api.smartloan.local`
- Ingress Controller: nginx
- SSL: Can be configured with cert-manager

### Setup Hosts File

```
127.0.0.1 api.smartloan.local
127.0.0.1 chatbot.smartloan.local
```

## Cleanup

```powershell
# Remove everything
.\cleanup.ps1

# Or manually
kubectl delete namespace smartloan-ai
```

## Production Considerations

### Security

- [ ] Create dedicated ServiceAccounts
- [ ] RBAC permissions
- [ ] Network policies
- [ ] Pod security standards
- [ ] Secrets encryption

### High Availability

- [ ] Multiple replicas
- [ ] Anti-affinity rules
- [ ] Load balancing
- [ ] Database clustering
- [ ] Cross-zone deployment

### Monitoring

- [ ] Prometheus metrics
- [ ] Grafana dashboards
- [ ] AlertManager rules
- [ ] Logging aggregation

### Backup

- [ ] Database backups
- [ ] Volume snapshots
- [ ] Configuration backups

## Troubleshooting

### Common Issues

1. **Image Pull Errors**
   - Check registry access
   - Verify image tags
   - Check pull secrets

2. **Database Connection**
   - Verify service DNS
   - Check environment variables
   - Review database logs

3. **Resource Limits**
   - Monitor resource usage
   - Adjust requests/limits
   - Check node capacity

4. **Storage Issues**
   - Verify PV/PVC status
   - Check storage class
   - Monitor disk space
   - Check storage class
   - Monitor disk space -->
