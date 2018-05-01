FROM eawsy/aws-lambda-go-shim:latest

ENV SERVERLESS="serverless@1.25.0" \
    GOPATH="/go" \
    PATH="${GOPATH}/bin:/root/.yarn/bin:${PATH}" \
    AWS_CLI_VERSION="1.11.131"

RUN true && \
    yum -q -e 0 -y update || true && \
    yum -q -e 0 -y install epel-release || true && \
    yum -q -e 0 -y install python-pip || true && \
    yum -q -e 0 -y install git || true
RUN pip-python --no-cache-dir install awscli==${AWS_CLI_VERSION}
RUN	go get -u github.com/golang/dep/cmd/dep && \
    go get -u github.com/rancher/trash && \
    curl https://glide.sh/get | sh ||  true
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
 	yum install -y nodejs
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN npm install -g $SERVERLESS

ENV PACKAGE_PATH="${GOPATH}/src/packages" \
    GOBIN="${PACKAGE_PATH}/bin"
RUN mkdir -pv "${PACKAGE_PATH}/bin"
