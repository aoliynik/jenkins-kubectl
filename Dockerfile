FROM bitnami/jenkins:2.426.2-debian-11-r0

ARG KUBECTL_VERSION=1.25.16
ARG HELM_VERSION=3.13.3
ARG HELMFILE_VERSION=0.159.0

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
RUN helm plugin install https://github.com/databus23/helm-diff --version v3.8.1 && \
    helm plugin install https://github.com/jkroepke/helm-secrets --version v4.5.1 && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version v0.15.1 && \
    helm plugin install https://github.com/aslafy-z/helm-git.git --version v0.15.1

# Install helmfile
RUN curl -LO "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" && \
    tar -zxvf helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz && \
    mv helmfile /usr/local/bin/helmfile && \
    rm -rf linux-amd64 helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz

# Install aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf aws awscliv2.zip

USER 1001
