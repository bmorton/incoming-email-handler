# Incoming email to HTTP handler

This is a Dockerfile for handling email addressed to *@yourdomain.com and HTTP
POSTed to a given endpoint with a predefined security token.

## How to use

Edit the DOMAIN, SHARED_SECRET, and POST_ENDPOINT environment variables in this
Dockerfile and build the image.

## Running the container

```
docker run -h mail.domain.com -p 25:25 -t -i bmorton/incoming
```
