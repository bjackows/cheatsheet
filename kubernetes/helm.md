### Template subchart based on global values.yaml

```
helm template charts/<subchart> -f <(yq r values.yaml '<subchart>')
```
