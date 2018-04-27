# Serverless Golang

[![Serverless Badge](http://public.serverless.com/badges/v3.svg)](http://www.serverless.com). 


## Performance
For AWS, we leverage eawsy's python based [AWS Lambda Go Shim](https://github.com/eawsy/aws-lambda-go-shim) for performance compared to other shims:

## Features
- seamless integration with AWS Lambda event sources or API Gateway HTTP requests.
- use `docker` and `docker-compose` for easy testing with [localstack](https://github.com/localstack/localstack) and ensure consistent dependencies across `golang`, `python` and `serverless`
- docker builder image immutably baked in with: 
  - amazon linux base image for building AWS Lambda
  - go 1.9.2
  - python 2.7
  - node 6
  - serverless 1.25.0

## Usage
Prerequisites:
- have `serverless`, `go`, `make` and `docker`
- have correct `$GOPATH` and your new project must reside in `$GOPATH/src/path/your-app`

Build image based on yunspace/serverless-golang image:

- [Serverless Golang Docker Image](https://github.com/yunspace/serverless-golang/)


