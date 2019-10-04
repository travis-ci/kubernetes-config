{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gce-worker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gce-worker.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "worker" .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gce-worker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Use the fullname as the secret name unless a secretName has been provided.
*/}}
{{- define "gce-worker.secret" -}}
{{- if .Values.secretName -}}
{{- .Values.secretName -}}
{{- else -}}
{{- include "gce-worker.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Get the config/secrets created by Terraform.
*/}}
{{- define "gce-worker.terraform" -}}
{{- if .Values.terraformSecretName -}}
{{- .Values.terraformSecretName -}}
{{- else -}}
{{- include "gce-worker.fullname" . }}-terraform
{{- end -}}
{{- end -}}

{{/*
Custom prefix for LIBRATO_SOURCE.
*/}}
{{- define "gce-worker.librato_source_prefix" -}}
{{- if .Values.librato_source_prefix -}}
{{- .Values.librato_source_prefix -}}
{{- else -}}
{{- .Release.Namespace -}}
{{- end -}}
{{- end -}}
