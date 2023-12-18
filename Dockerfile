FROM bitnami/jenkins:2.426.2-debian-11-r0

ENV KUBECTL_VERSION=1.22.2
ENV HELM_VERSION=3.7.0

USER root

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install helm
RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64 helm-v${HELM_VERSION}-linux-amd64.tar.gz

# Install helm plugins
RUN helm plugin install https://github.com/databus23/helm-diff --version v3.3.1 && \
    helm plugin install https://github.com/jkroepke/helm-secrets --version v3.5.0 && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version v0.10.0 && \
    helm plugin install https://github.com/aslafy-z/helm-git.git --version v0.10.0

USER 1001
