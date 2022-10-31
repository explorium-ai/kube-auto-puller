# Kube-Auto-Puller

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=for-the-badge)

![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=for-the-badge)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kube-auto-puller)](https://artifacthub.io/packages/search?repo=kube-auto-puller)
## Description

A Kubernetes Image Puller and Cacher with Automatic Discovery

## Usage

- Configure general values
    ```yaml
    global:
    # -- Defines the secrets which will be used to pull images into nodes and cache them
    imageCachePullSecrets: []
   
    # -- # List of images to exclude when creating image caches. works with Regex
    exclude:
      - ".*kube-proxy.*"
   
    cacheAllOnDeploy:
      # -- On Chart install, automatically create all caches for all images in the cluster (respecting excluded list)
      enabled: true
    ```
- Install latest version of kube-auto-puller helm chart

    ```
    $ helm repo add kube-auto-puller https://explorium-ai.github.io/kube-auto-puller/
    $ helm repo update
    $ helm install kube-auto-puller/kube-auto-puller -n kube-system -f values.yaml
    ```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ecr-creds.aws.account | string | `""` | AWS Account ID |
| ecr-creds.aws.credentials.accessKey | Optional if service account with role exists | `""` | AWS Account Access Key |
| ecr-creds.aws.credentials.secretKey | Optional if service account with role exists | `""` | AWS Account Access Key ID |
| ecr-creds.aws.region | string | `""` | AWS Account Region |
| ecr-creds.enabled | bool | `false` | Creates an automatic ECR renew sub-chart for creating an ECR authenticating secret in the namespace. |
| ecr-creds.fullnameOverride | string | `""` | String to override the default generated fullname |
| ecr-creds.image.pullPolicy | string | `"IfNotPresent"` | The docker image pull policy |
| ecr-creds.image.repository | string | `"docker.io/bhuwanupadhyay/ecr-creds"` | The docker image repository to use |
| ecr-creds.image.tag | string | `""` | The docker image tag to use |
| ecr-creds.imagePullSecrets | list | `[]` | Image Pull Secrets |
| ecr-creds.nameOverride | string | `""` | String to override the default generated name |
| ecr-creds.serviceAccount.annotations | object | `{}` | Additional annotations |
| ecr-creds.serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| ecr-creds.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. yamllint disable-line rule:line-length If not set and create is true, a name is generated using the fullname template |
| ecr-creds.targetPullSecretName | string | `"aws-ecr-creds"` | The name of the ECR creds secret to create. Make use to reference it in the chart. |
| exporter.affinity | object | `{}` | Set the affinity for the pod. |
| exporter.image.pullPolicy | string | `"IfNotPresent"` | The docker image pull policy |
| exporter.image.repository | string | `"registry.aliyuncs.com/acs/kube-eventer-amd64"` | The docker image repository to use |
| exporter.image.tag | string | `"v1.2.4-0f5aaee-aliyun"` | The docker image tag to use |
| exporter.imagePullSecrets | list | `[]` | Image Pull Secrets |
| exporter.nodeSelector | object | `{}` | Set the node selector for the pod. |
| exporter.resources | object | `{"limits":{"cpu":"500m","memory":"250Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Set the resources requests and limits |
| exporter.tolerations | list | `[]` | Set the tolerations for the pod. |
| fullnameOverride | string | `""` | String to override the default generated fullname |
| global.cacheAllOnDeploy.enabled | bool | `true` | On Chart install, automatically create all caches for all images in the cluster |
| global.cacheAllOnDeploy.image.pullPolicy | string | `"IfNotPresent"` | The docker image pull policy |
| global.cacheAllOnDeploy.image.repository | string | `"bitnami/kubectl"` | The docker image repository to use |
| global.cacheAllOnDeploy.image.tag | string | `"1.25.3"` | The docker image tag to use |
| global.exclude | list | `[".*kube-proxy.*"]` | # List of images to exclude when creating image caches. works with Regex |
| global.imageCachePullSecrets | list | `[]` | Defines the secrets which will be used to pull images into nodes and cache them |
| kube-fledged.args.controllerImageCacheRefreshFrequency | string | `"1m"` | Time to refresh image caching |
| kube-fledged.webhookServer.enable | bool | `false` | Enabled a webhook server. (WARNING: Enabling breaks the chart. Validating webhook will invalidate certificates) |
| nameOverride | string | `""` | String to override the default generated name |
| webhook-receiver.affinity | object | `{}` | Set the affinity for the pod. |
| webhook-receiver.env | object | `{}` | Extra environment variables |
| webhook-receiver.fullnameOverride | string | `""` | String to override the default generated fullname |
| webhook-receiver.image.repository | string | `"weibeld/webhook-kubectl"` | The docker image repository to use |
| webhook-receiver.image.tag | string | `"0.0.2"` | The docker image tag to use |
| webhook-receiver.imagePullSecrets | list | `[]` | Image Pull Secrets |
| webhook-receiver.ingress.annotations | object | `{}` | Additional annotations |
| webhook-receiver.ingress.enabled | bool | `false` | Specifies what type of Ingress should be created |
| webhook-receiver.ingress.hosts | list | `[{"host":"webhook-receiver.chart.local","paths":["/"]}]` | Ingress host |
| webhook-receiver.ingress.tls | list | `[]` | Ingress tls |
| webhook-receiver.nameOverride | string | `""` | String to override the default generated name |
| webhook-receiver.nodeSelector | object | `{}` | Set the node selector for the pod. |
| webhook-receiver.podSecurityContext | object | `{}` |  |
| webhook-receiver.replicaCount | int | `2` | Numbers of replicas |
| webhook-receiver.resources | object | `{"limits":{"cpu":"500m","memory":"5123Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Set the resources requests and limits |
| webhook-receiver.securityContext | object | `{}` |  |
| webhook-receiver.service.port | int | `9000` | Default Service port |
| webhook-receiver.service.type | string | `"ClusterIP"` | Specifies what type of Service should be created |
| webhook-receiver.serviceAccount.annotations | object | `{}` | Additional annotations |
| webhook-receiver.serviceAccount.name | string | `"webhook-receiver"` | The name of the ServiceAccount to use. yamllint disable-line rule:line-length If not set and create is true, a name is generated using the fullname template |
| webhook-receiver.tolerations | list | `[]` | Set the tolerations for the pod. |

**Homepage:** <https://github.com/explorium-ai/kube-auto-puller>

## Source Code

* <https://github.com/explorium-ai/kube-auto-puller>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| explorium-ai | <devops@explorium.ai> | <https://www.explorium.ai/> |
