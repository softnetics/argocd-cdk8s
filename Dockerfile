FROM quay.io/argoproj/argocd:v2.9.3

# Switch to root for the ability to perform install
USER root

RUN apt-get update

# Install curl to download tools
RUN apt-get install -y curl

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install sops
RUN curl -LO https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64 \
    && mv sops-v3.8.1.linux.amd64 /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops

# Install yq
RUN curl -LO https://github.com/mikefarah/yq/releases/download/v4.40.5/yq_linux_amd64 \
    && mv yq_linux_amd64 /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Install jq
RUN apt-get install -y jq

# Install typescript and cdk8s-cli to make it easier to generate k8s manifests
RUN npm install -g typescript cdk8s-cli

# Switch back to non-root user
USER argocd