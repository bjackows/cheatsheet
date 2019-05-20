### Blueprint

```
exports.handler = function(event, context, cb) {
    const request = event.Records[0].cf.request;
    const response = event.Records[0].cf.response;

    const config = event.Records[0].cf.config;
    const host = config.distributionDomainName;

    return cb(null, response);
};
```

### Fetch from S3

```
var AWS = require('aws-sdk');
var s3 = new AWS.S3();

function readS3File(bucketName, filename, cb) {
    var params = { Bucket: bucketName, Key: filename };
    s3.getObject(params, function(err, data) {
        if (err) {
            return cb(null, err);
        }

        return cb(data.Body.toString(), null);
    });
}
```

### Replace body

```
response.body = "";
```

### Add headers

```
response.headers["content-type"] = [{
    "key": "Content-Type",
    "value": "text/html"
}];
```
