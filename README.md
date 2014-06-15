# Incoming email to HTTP handler

This is a Dockerfile for handling email addressed to *@yourdomain.com and HTTP
POSTed to a given endpoint with a predefined security token.

## How to use

Edit the DOMAIN environment variable in this Dockerfile and build the image.

## Running the container

```
docker run -h mail.domain.com -p 25:25 -t -i bmorton/incoming
```
