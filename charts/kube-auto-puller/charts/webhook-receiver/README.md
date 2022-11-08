# webhook-receiver

![Version: 1.0.9](https://img.shields.io/badge/Version-1.0.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.8.0](https://img.shields.io/badge/AppVersion-2.8.0-informational?style=flat-square)

A Helm chart to recieve webhooks, and act accordingly.

**Homepage:** <https://geek-cookbook.funkypenguin.co.nz>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Thomas Hobson <HexF> | <thomas@hexf.me> | <https://hexf.me/> |
| David Young | <davidy@funkypenguin.co.nz> | <https://www.funkypenguin.co.nz> |

## Source Code

* <https://github.com/adnanh/webhook>
* <https://hub.docker.com/r/almir/webhook/>
* <https://github.com/almir/docker-webhook>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| env | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| hooks.puller.enable | bool | `true` |  |
| hooks.puller.files."/data/cache.sh" | string | `"#!/bin/bash\nimage=$(echo $1 | tr ' ' '\\n' | grep \":\" | xargs)\nname=$(echo $image | cut -d \"/\" -f2 | sed \"s/[^[:alnum:]-]//g\")\nexcluded_images=(\n{{- with .Values.global.exclude }}\n  {{- range . }}\n  {{ . | quote }}\n  {{- end }}\n{{- end }}\n)\nincluded_images=(\n{{- with .Values.global.include }}\n  {{- range . }}\n  {{ . | quote }}\n  {{- end }}\n{{- end }}\n)        \nexclude=false\nfor regex in \"${excluded_images[@]}\"; do\n  if echo $image | grep -q -x -e \"$regex\"; then\n    exclude=true\n    echo \"Excluded contains $image\"\n  fi\ndone\nfor regex in \"${included_images[@]}\"; do\n  if echo $image | grep -q -v -x -e \"$regex\"; then\n    exclude=true\n    echo \"Included does not contain $image\"\n  fi\ndone\nif [ \"$exclude\" = false ]; then\necho \"Creating Cache for Image: $image. Name: $name\"\ncat <<EOF | kubectl apply -f -\napiVersion: kubefledged.io/v1alpha2\nkind: ImageCache\nmetadata:\n  name: $(echo -n $name)\n  labels:\n    app: kubefledged\n    kubefledged: imagecache\nspec:\n  cacheSpec:\n  - images:\n    - $(echo -n $image)\n  {{- with .Values.global.imageCachePullSecrets }}\n  imagePullSecrets:\n  {{- toYaml . | nindent 4 }}\n  {{- end }}\nEOF\nfi\n"` |  |
| hooks.puller.hook.execute-command | string | `"/data/cache.sh"` |  |
| hooks.puller.hook.id | string | `"puller"` |  |
| hooks.puller.hook.incoming-payload-content-type | string | `"application/json"` |  |
| hooks.puller.hook.pass-arguments-to-command[0].name | string | `"EventMessage"` |  |
| hooks.puller.hook.pass-arguments-to-command[0].source | string | `"payload"` |  |
| hooks.remover.enable | bool | `true` |  |
| hooks.remover.files."/data/delete.sh" | string | `"#!/bin/bash\n# yamllint disable-line rule:line-length\n# yamllint disable-line rule:line-length\nhashed_cached_images=$(kubectl get imagecaches -A -o=custom-columns='DATA:metadata.name' | awk '!seen[$0]++')\nhashed_cached_images=${hashed_cached_images#*$'\\n'}\n# yamllint disable-line rule:line-length\n# yamllint disable-line rule:line-length\nrelevant_images=$(kubectl get pods -A -o=custom-columns='DATA:spec.containers[*].image' | tr ',' '\\n' | awk '!seen[$0]++')\nrelevant_images=${relevant_images#*$'\\n'}\nSAVEIFS=$IFS\nIFS=$'\\n'\nrelevant_images=($relevant_images)\nhashed_cached_images=($hashed_cached_images)\nIFS=$SAVEIFS\nfor i in \"${!relevant_images[@]}\"; do\n  # yamllint disable-line rule:line-length\n  # yamllint disable-line rule:line-length\n  relevant_images[$i]=$(echo ${relevant_images[$i]} | cut -d \"/\" -f2 | sed \"s/[^[:alnum:]-]//g\")\ndone\necho ${relevant_images[@]}\nfor i in \"${hashed_cached_images[@]}\"\ndo\necho \"Checking image $i\"\nif [[ ! \" ${relevant_images[*]} \" =~ \" ${i} \" ]]; then\n  # yamllint disable-line rule:line-length\n  # yamllint disable-line rule:line-length\n  image=$(kubectl get imagecaches $i -o=custom-columns='DATA:spec.cacheSpec[0].images[0]')\n  image=${image#*$'\\n'}\n  echo $image is no longer in the cluster. purging cache...\n  # yamllint disable-line rule:line-length\n  # yamllint disable-line rule:line-length\n  kubectl annotate --overwrite imagecaches $i kubefledged.io/purge-imagecache=\n  sleep 1\n  # yamllint disable-line rule:line-length\n  # yamllint disable-line rule:line-length\n  status=$(kubectl get imagecaches $i -o json | jq .status.status | xargs)\n  # yamllint disable-line rule:line-length\n  # yamllint disable-line rule:line-length\n  message=$(kubectl get imagecaches $i -o json | jq .status.message | xargs)\n  until [ $status != \"Processing\" ]\n  do\n      echo Status: $status\n      echo Status: $message\n      # yamllint disable-line rule:line-length\n      # yamllint disable-line rule:line-length\n      status=$(kubectl get imagecaches $i -o json | jq .status.status | xargs)\n      message=$(kubectl get imagecaches $i -o json | jq .status.message)\n      # yamllint disable-line rule:line-length\n      # yamllint disable-line rule:line-length\n      kubectl annotate --overwrite imagecaches $i kubefledged.io/purge-imagecache=\n  done\n  kubectl delete imagecaches $i\n  echo Status: $status\n  echo Message: $message\nfi\ndone\n"` |  |
| hooks.remover.hook.execute-command | string | `"/data/delete.sh"` |  |
| hooks.remover.hook.id | string | `"remover"` |  |
| hooks.remover.hook.incoming-payload-content-type | string | `"application/json"` |  |
| hooks.status.enable | bool | `true` |  |
| hooks.status.files."/data/status.sh" | string | `"#!/bin/sh\necho Healthy\n"` |  |
| hooks.status.hook.execute-command | string | `"/data/status.sh"` |  |
| hooks.status.hook.id | string | `"status"` |  |
| hooks.status.hook.incoming-payload-content-type | string | `"text/plain"` |  |
| hooks.status.hook.response-message | string | `"Online"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"almir/webhook"` |  |
| image.tag | string | `"2.8.0"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0].host | string | `"webhook-receiver.chart.local"` |  |
| ingress.hosts[0].paths[0] | string | `"/"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `9000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `"webhook-receiver"` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
