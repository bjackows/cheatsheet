### Create a certificate and key pair automatically

```
openssl req -new -newkey rsa:2048 \
  -sha256 -days 365 -nodes -x509 \
  -keyout key.pem  -out crt.pem -subj "/C=US/ST=MA/L=here/O=org/OU=test/CN=test.nonexistant"
```

### Openssl 1.1.0 to 1.1.1 backward

Add this on openssl 1.1.1 to decrypt from encrypted 1.1.0

```
-md md5
```
