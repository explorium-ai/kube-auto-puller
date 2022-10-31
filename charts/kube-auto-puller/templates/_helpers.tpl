{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "image-puller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "image-puller.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "image-puller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "image-puller.labels" -}}
helm.sh/chart: {{ include "image-puller.chart" . }}
{{ include "image-puller.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "image-puller.selectorLabels" -}}
app.kubernetes.io/name: {{ include "image-puller.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "image-puller.selectorLabelsExporter" -}}
app.kubernetes.io/name: {{ include "image-puller.name" . | trunc 50 | trimSuffix "-" }}-kube-eventer
app.kubernetes.io/instance: {{ .Release.Name }}-kube-eventer
{{- end }}

{{/*
Return true if a secret object should be created
*/}}
{{- define "image-puller.createSecret" -}}
{{- if and .Values.aws.credentials.secretKey .Values.aws.credentials.accessKey }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}
