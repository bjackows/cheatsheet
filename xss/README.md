### Caveats
- does not executes `<script>` after page loaded
- When browsers parse tag attributes, they HTML-decode their values first. <foo bar='z'> is the same as <foo bar='&#x7a;'


### Payloads

- `<img src=1 onerror=alert(1)>">`

### Links
- https://netsec.expert/2020/02/01/xss-in-2020.html
- https://xss.pwnfunction.com/
- https://www.google.com/about/appsecurity/learning/xss/index.html
