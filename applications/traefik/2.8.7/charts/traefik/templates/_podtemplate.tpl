{{- define "traefik.podTemplate" }}
    metadata:
      annotations:
      {{- with .Values.deployment.podAnnotations }}
      {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .Values.metrics }}
      {{- if .Values.metrics.prometheus }}
        prometheus.io/scrape: "true"
        prometheus.io/path: "/metrics"
        prometheus.io/port: {{ quote (index .Values.ports .Values.metrics.prometheus.entryPoint).port }}
      {{- end }}
      {{- end }}
      labels:
        app.kubernetes.io/name: {{ template "traefik.name" . }}
        helm.sh/chart: {{ template "traefik.chart" . }}
        app.kubernetes.io/managed-by: {{ .Release.Service }}
        app.kubernetes.io/instance: {{ .Release.Name }}
      {{- with .Values.deployment.podLabels }}
      {{- toYaml . | nindent 8 }}
      {{- end }}
    spec:
      {{- with .Values.deployment.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "traefik.serviceAccountName" . }}
      terminationGracePeriodSeconds: {{ default 60 .Values.deployment.terminationGracePeriodSeconds }}
      hostNetwork: {{ .Values.hostNetwork }}
      {{- with .Values.deployment.dnsPolicy }}
      dnsPolicy: {{ . }}
      {{- end }}
      {{- with .Values.deployment.initContainers }}
      initContainers:
      {{- toYaml . | nindent 6 }}
      {{- end }}
      {{- if .Values.deployment.shareProcessNamespace }}
      shareProcessNamespace: true
      {{- end }}
      containers:
      - image: "{{ .Values.image.name }}:{{ default .Chart.AppVersion .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        name: {{ template "traefik.fullname" . }}
        resources:
          {{- with .Values.resources }}
          {{- toYaml . | nindent 10 }}
          {{- end }}
        readinessProbe:
          httpGet:
            path: /ping
            port: {{ default .Values.ports.traefik.port .Values.ports.traefik.healthchecksPort }}
            scheme: {{ default "HTTP" .Values.ports.traefik.healthchecksScheme }}
          {{- toYaml .Values.readinessProbe | nindent 10 }}
        livenessProbe:
          httpGet:
            path: /ping
            port: {{ default .Values.ports.traefik.port .Values.ports.traefik.healthchecksPort }}
            scheme: {{ default "HTTP" .Values.ports.traefik.healthchecksScheme }}
          {{- toYaml .Values.livenessProbe | nindent 10 }}
        lifecycle:
          {{- with .Values.deployment.lifecycle }}
          {{- toYaml . | nindent 10 }}
          {{- end }}
        ports:
        {{- range $name, $config := .Values.ports }}
        {{- if $config }}
        - name: {{ $name | quote }}
          containerPort: {{ $config.port }}
          {{- if $config.hostPort }}
          hostPort: {{ $config.hostPort }}
          {{- end }}
          {{- if $config.hostIP }}
          hostIP: {{ $config.hostIP }}
          {{- end }}
          protocol: {{ default "TCP" $config.protocol | quote }}
        {{- end }}
        {{- end }}
        {{- with .Values.securityContext }}
        securityContext:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        volumeMounts:
          - name: {{ .Values.persistence.name }}
            mountPath: {{ .Values.persistence.path }}
            {{- if .Values.persistence.subPath }}
            subPath: {{ .Values.persistence.subPath }}
            {{- end }}
          - name: tmp
            mountPath: /tmp
          {{- $root := . }}
          {{- range .Values.volumes }}
          - name: {{ tpl (.name) $root }}
            mountPath: {{ .mountPath }}
            readOnly: true
          {{- end }}
          {{- if .Values.experimental.plugins.enabled }}
          - name: plugins
            mountPath: "/plugins-storage"
          {{- end }}
          {{- if .Values.additionalVolumeMounts }}
            {{- toYaml .Values.additionalVolumeMounts | nindent 10 }}
          {{- end }}
        args:
          {{- with .Values.globalArguments }}
          {{- range . }}
          - {{ . | quote }}
          {{- end }}
          {{- end }}
          {{- range $name, $config := .Values.ports }}
          {{- if $config }}
          - "--entrypoints.{{$name}}.address=:{{ $config.port }}/{{ default "tcp" $config.protocol | lower }}"
          {{- end }}
          {{- end }}
          - "--api.dashboard=true"
          - "--ping=true"
          {{- if .Values.metrics }}
          {{- if .Values.metrics.datadog }}
          - "--metrics.datadog=true"
          {{- if .Values.metrics.datadog.address }}
          - "--metrics.datadog.address={{ .Values.metrics.datadog.address }}"
          {{- end }}
          {{- end }}
          {{- if .Values.metrics.influxdb }}
          - "--metrics.influxdb=true"
          - "--metrics.influxdb.address={{ .Values.metrics.influxdb.address }}"
          - "--metrics.influxdb.protocol={{ .Values.metrics.influxdb.protocol }}"
          {{- end }}
          {{- if .Values.metrics.prometheus }}
          - "--metrics.prometheus=true"
          - "--metrics.prometheus.entrypoint={{ .Values.metrics.prometheus.entryPoint }}"
          {{- if .Values.metrics.prometheus.addRoutersLabels }}
          - "--metrics.prometheus.addRoutersLabels=true"
          {{- end }}
          {{- end }}
          {{- if .Values.metrics.statsd }}
          - "--metrics.statsd=true"
          - "--metrics.statsd.address={{ .Values.metrics.statsd.address }}"
          {{- end }}
          {{- end }}
          {{- if .Values.tracing }}
          {{- if .Values.tracing.instana }}
          - "--tracing.instana=true"
          {{- if .Values.tracing.instana.localAgentHost }}
          - "--tracing.instana.localAgentHost={{ .Values.tracing.instana.localAgentHost }}"
          {{- end }}
          {{- if .Values.tracing.instana.localAgentPort }}
          - "--tracing.instana.localAgentPort={{ .Values.tracing.instana.localAgentPort }}"
          {{- end }}
          {{- if .Values.tracing.instana.logLevel }}
          - "--tracing.instana.logLevel={{ .Values.tracing.instana.logLevel }}"
          {{- end }}
          {{- if .Values.tracing.instana.enableAutoProfile }}
          - "--tracing.instana.enableAutoProfile={{ .Values.tracing.instana.enableAutoProfile }}"
          {{- end }}
          {{- end }}
          {{- if .Values.tracing.datadog }}
          - "--tracing.datadog=true"
          {{- if .Values.tracing.datadog.localAgentHostPort }}
          - "--tracing.datadog.localAgentHostPort={{ .Values.tracing.datadog.localAgentHostPort }}"
          {{- end }}
          {{- if .Values.tracing.datadog.debug }}
          - "--tracing.datadog.debug=true"
          {{- end }}
          {{- if .Values.tracing.datadog.globalTag }}
          - "--tracing.datadog.globalTag={{ .Values.tracing.datadog.globalTag }}"
          {{- end }}
          {{- if .Values.tracing.datadog.prioritySampling }}
          - "--tracing.datadog.prioritySampling=true"
          {{- end }}
          {{- end }}
          {{- if .Values.tracing.jaeger }}
          - "--tracing.jaeger=true"
          {{- if .Values.tracing.jaeger.samplingServerURL }}
          - "--tracing.jaeger.samplingServerURL={{ .Values.tracing.jaeger.samplingServerURL }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.samplingType }}
          - "--tracing.jaeger.samplingType={{ .Values.tracing.jaeger.samplingType }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.samplingParam }}
          - "--tracing.jaeger.samplingParam={{ .Values.tracing.jaeger.samplingParam }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.localAgentHostPort }}
          - "--tracing.jaeger.localAgentHostPort={{ .Values.tracing.jaeger.localAgentHostPort }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.gen128Bit }}
          - "--tracing.jaeger.gen128Bit={{ .Values.tracing.jaeger.gen128Bit }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.propagation }}
          - "--tracing.jaeger.propagation={{ .Values.tracing.jaeger.propagation }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.traceContextHeaderName }}
          - "--tracing.jaeger.traceContextHeaderName={{ .Values.tracing.jaeger.traceContextHeaderName }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.disableAttemptReconnecting }}
          - "--tracing.jaeger.disableAttemptReconnecting={{ .Values.tracing.jaeger.disableAttemptReconnecting }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.collector }}
          {{- if .Values.tracing.jaeger.collector.endpoint }}
          - "--tracing.jaeger.collector.endpoint={{ .Values.tracing.jaeger.collector.endpoint }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.collector.user }}
          - "--tracing.jaeger.collector.user={{ .Values.tracing.jaeger.collector.user }}"
          {{- end }}
          {{- if .Values.tracing.jaeger.collector.password }}
          - "--tracing.jaeger.collector.password={{ .Values.tracing.jaeger.collector.password }}"
          {{- end }}
          {{- end }}
          {{- end }}
          {{- if .Values.tracing.zipkin }}
          - "--tracing.zipkin=true"
          {{- if .Values.tracing.zipkin.httpEndpoint }}
          - "--tracing.zipkin.httpEndpoint={{ .Values.tracing.zipkin.httpEndpoint }}"
          {{- end }}
          {{- if .Values.tracing.zipkin.sameSpan }}
          - "--tracing.zipkin.sameSpan={{ .Values.tracing.zipkin.sameSpan }}"
          {{- end }}
          {{- if .Values.tracing.zipkin.id128Bit }}
          - "--tracing.zipkin.id128Bit={{ .Values.tracing.zipkin.id128Bit }}"
          {{- end }}
          {{- if .Values.tracing.zipkin.sampleRate }}
          - "--tracing.zipkin.sampleRate={{ .Values.tracing.zipkin.sampleRate }}"
          {{- end }}
          {{- end }}
          {{- if .Values.tracing.haystack }}
          - "--tracing.haystack=true"
          {{- if .Values.tracing.haystack.localAgentHost }}
          - "--tracing.haystack.localAgentHost={{ .Values.tracing.haystack.localAgentHost }}"
          {{- end }}
          {{- if .Values.tracing.haystack.localAgentPort }}
          - "--tracing.haystack.localAgentPort={{ .Values.tracing.haystack.localAgentPort }}"
          {{- end }}
          {{- if .Values.tracing.haystack.globalTag }}
          - "--tracing.haystack.globalTag={{ .Values.tracing.haystack.globalTag }}"
          {{- end }}
          {{- if .Values.tracing.haystack.traceIDHeaderName }}
          - "--tracing.haystack.traceIDHeaderName={{ .Values.tracing.haystack.traceIDHeaderName }}"
          {{- end }}
          {{- if .Values.tracing.haystack.parentIDHeaderName }}
          - "--tracing.haystack.parentIDHeaderName={{ .Values.tracing.haystack.parentIDHeaderName }}"
          {{- end }}
          {{- if .Values.tracing.haystack.spanIDHeaderName }}
          - "--tracing.haystack.spanIDHeaderName={{ .Values.tracing.haystack.spanIDHeaderName }}"
          {{- end }}
          {{- if .Values.tracing.haystack.baggagePrefixHeaderName }}
          - "--tracing.haystack.baggagePrefixHeaderName={{ .Values.tracing.haystack.baggagePrefixHeaderName }}"
          {{- end }}
          {{- end }}
          {{- if .Values.tracing.elastic }}
          - "--tracing.elastic=true"
          {{- if .Values.tracing.elastic.serverURL }}
          - "--tracing.elastic.serverURL={{ .Values.tracing.elastic.serverURL }}"
          {{- end }}
          {{- if .Values.tracing.elastic.secretToken }}
          - "--tracing.elastic.secretToken={{ .Values.tracing.elastic.secretToken }}"
          {{- end }}
          {{- if .Values.tracing.elastic.serviceEnvironment }}
          - "--tracing.elastic.serviceEnvironment={{ .Values.tracing.elastic.serviceEnvironment }}"
          {{- end }}
          {{- end }}
          {{- end }}
          {{- if .Values.providers.kubernetesCRD.enabled }}
          - "--providers.kubernetescrd"
          {{- if .Values.providers.kubernetesCRD.labelSelector }}
          - "--providers.kubernetescrd.labelSelector={{ .Values.providers.kubernetesCRD.labelSelector }}"
          {{- end }}
          {{- if .Values.providers.kubernetesCRD.ingressClass }}
          - "--providers.kubernetescrd.ingressClass={{ .Values.providers.kubernetesCRD.ingressClass }}"
          {{- end }}
          {{- if .Values.providers.kubernetesCRD.allowCrossNamespace }}
          - "--providers.kubernetescrd.allowCrossNamespace=true"
          {{- end }}
          {{- if .Values.providers.kubernetesCRD.allowExternalNameServices }}
          - "--providers.kubernetescrd.allowExternalNameServices=true"
          {{- end }}
          {{- if .Values.providers.kubernetesCRD.allowEmptyServices }}
          - "--providers.kubernetescrd.allowEmptyServices=true"
          {{- end }}
          {{- end }}
          {{- if .Values.providers.kubernetesIngress.enabled }}
          - "--providers.kubernetesingress"
          {{- if .Values.providers.kubernetesIngress.allowExternalNameServices }}
          - "--providers.kubernetesingress.allowExternalNameServices=true"
          {{- end }}
          {{- if .Values.providers.kubernetesIngress.allowEmptyServices }}
          - "--providers.kubernetesingress.allowEmptyServices=true"
          {{- end }}
          {{- if and .Values.service.enabled .Values.providers.kubernetesIngress.publishedService.enabled }}
          - "--providers.kubernetesingress.ingressendpoint.publishedservice={{ template "providers.kubernetesIngress.publishedServicePath" . }}"
          {{- end }}
          {{- if .Values.providers.kubernetesIngress.labelSelector }}
          - "--providers.kubernetesingress.labelSelector={{ .Values.providers.kubernetesIngress.labelSelector }}"
          {{- end }}
          {{- if .Values.providers.kubernetesIngress.ingressClass }}
          - "--providers.kubernetesingress.ingressClass={{ .Values.providers.kubernetesIngress.ingressClass }}"
          {{- end }}
          {{- end }}
          {{- if .Values.experimental.kubernetesGateway.enabled }}
          - "--providers.kubernetesgateway"
          - "--experimental.kubernetesgateway"
          {{- end }}
          {{- if .Values.experimental.http3.enabled }}
          - "--experimental.http3=true"
          {{- end }}
          {{- if and .Values.rbac.enabled .Values.rbac.namespaced }}
          {{- if .Values.providers.kubernetesCRD.enabled }}
          - "--providers.kubernetescrd.namespaces={{ template "providers.kubernetesCRD.namespaces" . }}"
          {{- end }}
          {{- if .Values.providers.kubernetesIngress.enabled }}
          - "--providers.kubernetesingress.namespaces={{ template "providers.kubernetesIngress.namespaces" . }}"
          {{- end }}
          {{- end }}
          {{- range $entrypoint, $config := $.Values.ports }}
          {{- if $config.redirectTo }}
          {{- $toPort := index $.Values.ports $config.redirectTo }}
          - "--entrypoints.{{ $entrypoint }}.http.redirections.entryPoint.to=:{{ $toPort.exposedPort }}"
          - "--entrypoints.{{ $entrypoint }}.http.redirections.entryPoint.scheme=https"
          {{- end }}
          {{- if $config.tls }}
          {{- if $config.tls.enabled }}
          - "--entrypoints.{{ $entrypoint }}.http.tls=true"
          {{- if $config.tls.options }}
          - "--entrypoints.{{ $entrypoint }}.http.tls.options={{ $config.tls.options }}"
          {{- end }}
          {{- if $config.tls.certResolver }}
          - "--entrypoints.{{ $entrypoint }}.http.tls.certResolver={{ $config.tls.certResolver }}"
          {{- end }}
          {{- if $config.tls.domains }}
          {{- range $index, $domain := $config.tls.domains }}
          {{- if $domain.main }}
          - "--entrypoints.{{ $entrypoint }}.http.tls.domains[{{ $index }}].main={{ $domain.main }}"
          {{- end }}
          {{- if $domain.sans }}
          - "--entrypoints.{{ $entrypoint }}.http.tls.domains[{{ $index }}].sans={{ join "," $domain.sans }}"
          {{- end }}
          {{- end }}
          {{- end }}
          {{- if $config.http3 }}
          {{- if semverCompare ">=2.6.0" (default $.Chart.AppVersion $.Values.image.tag)}}
          - "--entrypoints.{{ $entrypoint }}.http3.advertisedPort={{ default $config.port $config.exposedPort }}"
          {{- else }}
          - "--entrypoints.{{ $entrypoint }}.enableHTTP3=true"
          {{- end }}
          {{- end }}
          {{- end }}
          {{- end }}
          {{- end }}
          {{- with .Values.logs }}
          {{- if .general.format }}
          - "--log.format={{ .general.format }}"
          {{- end }}
          {{- if ne .general.level "ERROR" }}
          - "--log.level={{ .general.level | upper }}"
          {{- end }}
          {{- if .access.enabled }}
          - "--accesslog=true"
          {{- if .access.format }}
          - "--accesslog.format={{ .access.format }}"
          {{- end }}
          {{- if .access.bufferingsize }}
          - "--accesslog.bufferingsize={{ .access.bufferingsize }}"
          {{- end }}
          {{- if .access.filters }}
          {{- if .access.filters.statuscodes }}
          - "--accesslog.filters.statuscodes={{ .access.filters.statuscodes }}"
          {{- end }}
          {{- if .access.filters.retryattempts }}
          - "--accesslog.filters.retryattempts"
          {{- end }}
          {{- if .access.filters.minduration }}
          - "--accesslog.filters.minduration={{ .access.filters.minduration }}"
          {{- end }}
          {{- end }}
          - "--accesslog.fields.defaultmode={{ .access.fields.general.defaultmode }}"
          {{- range $fieldname, $fieldaction := .access.fields.general.names }}
          - "--accesslog.fields.names.{{ $fieldname }}={{ $fieldaction }}"
          {{- end }}
          - "--accesslog.fields.headers.defaultmode={{ .access.fields.headers.defaultmode }}"
          {{- range $fieldname, $fieldaction := .access.fields.headers.names }}
          - "--accesslog.fields.headers.names.{{ $fieldname }}={{ $fieldaction }}"
          {{- end }}
          {{- end }}
          {{- end }}
          {{- if .Values.pilot.enabled }}
          - "--pilot.token={{ .Values.pilot.token }}"
          {{- end }}
          {{- if hasKey .Values.pilot "dashboard" }}
          - "--pilot.dashboard={{ .Values.pilot.dashboard }}"
          {{- end }}
          {{- range $resolver, $config := $.Values.certResolvers }}
          {{- range $option, $setting := $config }}
          {{- if kindIs "map" $setting }}
          {{- range $field, $value := $setting }}
          - "--certificatesresolvers.{{ $resolver }}.acme.{{ $option }}.{{ $field }}={{ if kindIs "slice" $value }}{{ join "," $value }}{{ else }}{{ $value }}{{ end }}"
          {{- end }}
          {{- else }}
          - "--certificatesresolvers.{{ $resolver }}.acme.{{ $option }}={{ $setting }}"
          {{- end }}
          {{- end }}
          {{- end }}
          {{- with .Values.additionalArguments }}
          {{- range . }}
          - {{ . | quote }}
          {{- end }}
          {{- end }}
        {{- with .Values.env }}
        env:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .Values.envFrom }}
        envFrom:
          {{- toYaml . | nindent 10 }}
        {{- end }}
      {{- if .Values.deployment.additionalContainers }}
        {{- toYaml .Values.deployment.additionalContainers | nindent 6 }}
      {{- end }}
      volumes:
        - name: {{ .Values.persistence.name }}
          {{- if .Values.persistence.enabled }}
          persistentVolumeClaim:
            claimName: {{ default (include "traefik.fullname" .) .Values.persistence.existingClaim }}
          {{- else }}
          emptyDir: {}
          {{- end }}
        - name: tmp
          emptyDir: {}
        {{- $root := . }}
        {{- range .Values.volumes }}
        - name: {{ tpl (.name) $root }}
          {{- if eq .type "secret" }}
          secret:
            secretName: {{ tpl (.name) $root }}
          {{- else if eq .type "configMap" }}
          configMap:
            name: {{ tpl (.name) $root }}
          {{- end }}
        {{- end }}
        {{- if .Values.deployment.additionalVolumes }}
          {{- toYaml .Values.deployment.additionalVolumes | nindent 8 }}
        {{- end }}
        {{- if .Values.experimental.plugins.enabled }}
        - name: plugins
          emptyDir: {}
        {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .Values.priorityClassName }}
      priorityClassName: {{ .Values.priorityClassName }}
      {{- end }}
      {{- with .Values.podSecurityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{ end -}}
