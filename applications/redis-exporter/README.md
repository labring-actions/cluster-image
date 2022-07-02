# redis exporter

[exporter](https://github.com/oliver006/redis_exporter)

# add config in prometheus values:

```
scrape_configs:
  - job_name: redis_exporter
    static_configs:
    - targets: ['redis-exporter-service:9121']
```
