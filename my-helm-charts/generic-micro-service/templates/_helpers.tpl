{{/*
Expand the name of the chart.
*/}}
{{- define "generic-micro-service.name" -}}
{{- if .Values.appName }}
{{- .Values.appName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- default .Values.nameOverride .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "generic-micro-service.fullname" -}}
{{- if .Values.appName }}
{{- .Values.appName | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
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
{{- define "generic-micro-service.chart" -}}
{{- if .Values.appName }}
{{- .Values.appName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "generic-micro-service.labels" -}}
helm.sh/chart: {{ include "generic-micro-service.chart" . }}
{{ include "generic-micro-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "generic-micro-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "generic-micro-service.name" . }}
app.kubernetes.io/instance: {{ if .Values.appName }}{{ .Values.appName }}{{ else }}{{ .Release.Name }}{{ end }}
apps: {{ if .Values.appName }}{{ .Values.appName }}{{ else }}{{ .Release.Name }}{{ end }}
k8s-app: {{ if .Values.appName }}{{ .Values.appName }}{{ else }}{{ .Release.Name }}{{ end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "generic-micro-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "generic-micro-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
