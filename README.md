# Kube Auto Puller

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/explorium-ai/kube-auto-puller)](https://img.shields.io/github/v/release/explorium-ai/kube-auto-puller)
[![Artifact Hub Explorium](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kube-auto-puller)](https://artifacthub.io/packages/helm/kube-auto-puller/kube-auto-puller)

**kube-auto-puller** is a kubernetes chart that is an aggregation of *multiple open-source projects*. 

It allows for creating and managing a cache of container images directly on the worker nodes of a kubernetes cluster. It uses [kube-fledged](https://github.com/senthilrch/kube-fledged) as its controller, an [events-exporter](https://github.com/AliyunContainerService/kube-eventer) to get Pulled/Killed images and a [webhook-server](https://github.com/adnanh/webhook) to apply/purge/remove the ImageCache CRDs maintained by kube-fledged.

Where it differs from other similar projects is that it allows for *automatic discovery* of images based on regex. There is no need for manual input of images and repositories.
## Install using Helm chart

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
## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on the process for submitting pull requests.

## Code of Conduct

Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details on our code of conduct, and how to report violations.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE.md](LICENSE.md) file for details
