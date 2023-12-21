{{/*
Conventional name of a Zafran object - short environment name + app name
*/}}
{{- define "zafran-app.name" -}}
{{- $envDict := dict "production" "prod" "staging" "stage" "development" "dev" }}
{{- printf "%s-%s"  (get $envDict .Values.common.envName) (.Values.common.appName) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Conventional name of a Zafran Service - object name + service-account
*/}}
{{- define "zafran-app.serviceName" -}}
{{- printf "%s-service" (include "zafran-app.name" .)  }}
{{- end }}

{{/*
Conventional name of a Zafran ServiceAccount - object name + service-account
*/}}
{{- define "zafran-app.serviceAccountName" -}}
{{- printf "%s-service-account" (include "zafran-app.name" .)  }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zafran-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zafran-app.labels" -}}
{{ include "zafran-app.selectorLabels" . }}
helm.sh/chart: {{ include "zafran-app.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Datadog labels
*/}}
{{- define "zafran-app.datadogLabels" -}}
{{- $common := default dict .Values.common -}}
{{- $monitoring := default dict $common.monitoring -}}
{{- $datadog := default dict $monitoring.datadog -}}
tags.datadoghq.com/env: {{ default "production" $datadog.envOverride }}
tags.datadoghq.com/service: {{ default (include "zafran-app.name" .) $datadog.serviceNameOverride }}
tags.datadoghq.com/version: {{ default "unknown" .Values.common.gitSha }}
{{- end }}

{{/*
Datadog environment variables
*/}}
{{- define "zafran-app.datadogEnv" -}}
{{- $common := default dict .Values.common -}}
{{- $monitoring := default dict $common.monitoring -}}
{{- $datadog := default dict $monitoring.datadog -}}
{{- if not $datadog.disableApmSocket -}}
- name: DD_TRACE_AGENT_URL
  value: unix:///var/run/datadog/apm.socket
{{- end }}
- name: DD_ENV
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.labels['tags.datadoghq.com/env']
- name: DD_SERVICE
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.labels['tags.datadoghq.com/service']
- name: DD_VERSION
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.labels['tags.datadoghq.com/version']
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zafran-app.selectorLabels" -}}
app: {{ include "zafran-app.name" . }}
{{- end }}

{{/*
Node anti-affinity selectors
*/}}
{{- define "zafran-app.nodeAffinitySelectors" -}}
- key: app
  operator: In
  values:
    - {{ include "zafran-app.name" . }}
{{- end }}
