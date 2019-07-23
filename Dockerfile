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

ENV GOLANG_VERSION="1.12.7" \
    GOOS=linux \
    GOARCH=amd64
ENV GOLANG_DOWNLOAD_URL="https://dl.google.com/go/go${GOLANG_VERSION}.${GOOS}-${GOARCH}.tar.gz" \
    GOLANG_DOWNLOAD_SHA256="66d83bfb5a9ede000e33c6579a91a29e6b101829ad41fffb5c5bb6c900e109d9"


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
    && apt-get install -y --no-install-recommends software-properties-common apt-utils=1.4.9 \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    nodejs\
    zip \
    unzip \
    python-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV TERRAFORM_VERSION="0.12.5"

# install terraform
RUN wget -qO /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip -d /bin /tmp/terraform.zip && chmod 755 /bin/terraform && rm -rf /tmp/*



ENV SERVERLESS_VERSION="1.48.3" \
    AWS_CLI_VERSION="1.16.204"

RUN true && pip install --upgrade setuptools \
    && pip --no-cache-dir install awscli==${AWS_CLI_VERSION}

RUN true && npm install -g npm@6.2.0 \
    && npm install -g serverless@$SERVERLESS_VERSION \
    && npm prune

CMD /bin/sh

