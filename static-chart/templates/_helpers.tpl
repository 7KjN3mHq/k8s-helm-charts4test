{{/*
Expand the name of the chart.
*/}}
{{- define "static-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "static-chart.fullname" -}}
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
{{- define "static-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "static-chart.labels" -}}
helm.sh/chart: {{ include "static-chart.chart" . }}
{{ include "static-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "static-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "static-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "static-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "static-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
if image force update
*/}}
{{- define "image.pull_policy" -}}
{{- if .Values.image.forceUpdate }}
    {{- printf "%s" "Always" -}}
{{- else -}}
    {{- printf "IfNotPresent" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "static-chart.ingress_path" -}}
{{- if .Values.ingress_subdir.path }}
{{- printf "%s(/|$)(.*)" .Values.ingress_subdir.path }}
{{- end }}
{{- end }}

Return drupal subdir
*/}}
{{- define "static-chart.subdir" -}}
{{- if .Values.ingress_subdir.path }}
    {{- printf "%s" ( trimPrefix "/" .Values.ingress_subdir.path ) -}}
{{- else -}}
    {{- printf "" -}}
{{- end -}}
{{- end -}}