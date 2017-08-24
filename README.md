Website for [cplee.org](http://www.cplee.org)

# Deploy
```aws s3 sync --acl "public-read" --sse "AES256" public/ s3://cplee.org/```
