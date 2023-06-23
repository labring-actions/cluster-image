{{/*
Expand the name of the chart.
*/}}
{{- define "openIM.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openIM.fullname" -}}
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
{{- define "openIM.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.api" -}}
{{- printf "api" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.push" -}}
{{- printf "push" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.msg_gateway" -}}
{{- printf "msg_gateway" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.msg_transfer" -}}
{{- printf "msg_transfer" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.cron_task" -}}
{{- printf "cron_task" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.rpc_auth" -}}
{{- printf "rpc_auth" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.rpc_conversation" -}}
{{- printf "rpc_conversation" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.rpc_friend" -}}
{{- printf "rpc_friend" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.rpc_group" -}}
{{- printf "rpc_group" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.rpc_msg" -}}
{{- printf "rpc_msg" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.rpc_third" -}}
{{- printf "rpc_third" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openIM.rpc_user" -}}
{{- printf "rpc_user" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openIM.labels" -}}
helm.sh/chart: {{ include "openIM.chart" . }}
{{ include "openIM.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openIM.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openIM.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "openIM.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "openIM.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Generate minio url based on the value of .Values.istio.minio and .Values.istio.publicIP */}}
{{- define "openIM.minioAPIURL" -}}
{{- if .Values.istio.minioAPI.domain }}
{{ .Values.istio.minioAPI.domain }}
{{- else }}
minio.api.{{ .Values.istio.publicIP }}.nip.io
{{- end }}
{{- end }}

{{/* Generate minio url based on the value of .Values.istio.minio and .Values.istio.publicIP */}}
{{- define "openIM.minioURL" -}}
{{- if .Values.istio.minio.domain }}
{{ .Values.istio.minio.domain }}
{{- else }}
minio.{{ .Values.istio.publicIP }}.nip.io
{{- end }}
{{- end }}

{{/* Generate api url based on the value of .Values.istio.minio and .Values.istio.publicIP */}}
{{- define "openIM.apiURL" -}}
{{- if .Values.istio.api.domain }}
{{ .Values.istio.api.domain }}
{{- else }}
api.{{ .Values.istio.publicIP }}.nip.io
{{- end }}
{{- end }}

{{/* Generate ws url based on the value of .Values.istio.minio and .Values.istio.publicIP */}}
{{- define "openIM.gatewayDomain" -}}
{{- if .Values.istio.gateway.domain }}
{{ .Values.istio.api.domain }}
{{- else }}
gateway.{{ .Values.istio.publicIP }}.nip.io
{{- end }}
{{- end }}
