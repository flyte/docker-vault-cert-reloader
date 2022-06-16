Use as an 'extraContainer' on the Vault Helm chart to notify Vault to reload its TLS certificate when it changes (because cert-manager renewed it, for example).

Add something like the following to your Helm chart values:

```yaml
  extraContainers:
    - name: cert-watcher
      image: ghcr.io/flyte/docker-vault-cert-reloader:1.0.4
      args:
        - /var/run/secrets/vault-tls/tls.crt
      volumeMounts:
        - name: vault-tls
          mountPath: /var/run/secrets/vault-tls
          readOnly: true
  shareProcessNamespace: true
```
