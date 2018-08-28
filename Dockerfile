FROM buildpack-deps:stretch-scm

#
# Maintained by Cloudline Solutions LLC
# CI pipeline build image for building Go lang application
# and deploying to AWS Lambda with serverless framework
#

LABEL maintainer="support@cloudline-solutions.com"

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION="1.11" \
    GOOS=linux \
    GOARCH=amd64
ENV GOLANG_DOWNLOAD_URL="https://dl.google.com/go/go${GOLANG_VERSION}.${GOOS}-${GOARCH}.tar.gz" \
    GOLANG_DOWNLOAD_SHA256="b3fcf280ff86558e0559e185b601c9eade0fd24c900b4c63cd14d1d38613e499"

RUN wget -q -O golang.tar.gz $GOLANG_DOWNLOAD_URL \
  && echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz && rm golang.tar.gz

ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:/usr/local/go/bin:${PATH}" \
    PACKAGE_PATH="${GOPATH}/src/packages" \
    GOBIN="${GOPATH}/bin"

RUN mkdir -pv "${GOPATH}/src" "${GOPATH}/bin" && chmod -R 777 "${GOPATH}"

WORKDIR $GOPATH/src

#RUN go get -u github.com/rancher/trash && \
#    go get -u github.com/stretchr/testify/assert && \
#    curl https://glide.sh/get | sh

RUN true && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common apt-utils=1.4.8 \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    nodejs=8.11.4-1nodesource1 \
    zip=3.0-11+b1 \
    python-pip=9.0.1-2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV SERVERLESS_VERSION="1.30.3" \
    AWS_CLI_VERSION="1.16.2"

RUN true && pip install --upgrade setuptools \
    && pip --no-cache-dir install awscli==${AWS_CLI_VERSION}

RUN true && npm install -g npm@6.2.0 \
    && npm install -g serverless@$SERVERLESS_VERSION \
    && npm prune

CMD /bin/sh

