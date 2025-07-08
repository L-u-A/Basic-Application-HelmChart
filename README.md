# Basic Application Helm Chart

A comprehensive Helm chart for deploying a basic application on Kubernetes.

## Overview

This Helm chart provides a robust foundation for deploying containerized applications on Kubernetes. It includes all essential Kubernetes resources and follows best practices for production deployments.

## Features

- **Deployment**: Configurable deployment with rolling updates
- **Service**: ClusterIP, NodePort, or LoadBalancer service types
- **Ingress**: Optional ingress configuration with TLS support
- **Autoscaling**: Horizontal Pod Autoscaler (HPA) support
- **Security**: Pod security contexts and service accounts
- **Health Checks**: Configurable liveness and readiness probes
- **ConfigMaps**: Configuration management
- **Resource Management**: CPU and memory limits/requests
- **Affinity & Tolerations**: Node scheduling preferences

## Quick Start

### Prerequisites

- Kubernetes cluster (1.19+)
- Helm 3.0+

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd Basic-Application-HelmChart
```

2. Install the chart:
```bash
helm install my-app .
```

3. Verify the installation:
```bash
kubectl get pods
helm test my-app
```

### Accessing the Application

Follow the instructions in the NOTES.txt output after installation, or use:

```bash
kubectl port-forward service/my-app-basic-application 8080:80
```

Then access the application at http://localhost:8080

## Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `nginx` |
| `image.tag` | Container image tag | `1.21` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `ingress.enabled` | Enable ingress | `false` |
| `resources.limits.cpu` | CPU limit | `100m` |
| `resources.limits.memory` | Memory limit | `128Mi` |
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `1` |
| `autoscaling.maxReplicas` | Maximum replicas | `100` |

### Example Configurations

#### Basic Web Application
```yaml
# values-web.yaml
image:
  repository: nginx
  tag: "1.21"
  
service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix
```

#### Microservice with Autoscaling
```yaml
# values-microservice.yaml
replicaCount: 3

image:
  repository: myapp/api
  tag: "v1.0.0"

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi
```

## Customization

### Environment Variables

Configure environment variables in `values.yaml`:

```yaml
config:
  env:
    - name: DATABASE_URL
      value: "postgresql://localhost:5432/myapp"
    - name: LOG_LEVEL
      value: "info"
```

### Health Checks

Configure health check endpoints:

```yaml
probes:
  liveness:
    enabled: true
    path: /health
    initialDelaySeconds: 30
    periodSeconds: 10
  readiness:
    enabled: true
    path: /ready
    initialDelaySeconds: 5
    periodSeconds: 5
```

### Resource Management

Set appropriate resource limits:

```yaml
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi
```

## Development

### Testing

Run the included tests:

```bash
helm test my-app
```

### Linting

Validate the chart:

```bash
helm lint .
```

### Dry Run

Test the chart rendering:

```bash
helm install my-app . --dry-run --debug
```

## Upgrading

Upgrade the release:

```bash
helm upgrade my-app . --values values.yaml
```

## Uninstallation

Remove the release:

```bash
helm uninstall my-app
```

## Security Considerations

- Run as non-root user (UID 1000)
- Read-only root filesystem
- Dropped capabilities
- Security contexts enabled
- Service account with minimal permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue in the repository
- Contact the maintainers
- Check the documentation

## Changelog

### Version 0.1.0
- Initial release
- Basic deployment, service, and ingress support
- Autoscaling capabilities
- Security best practices
- Comprehensive documentation
