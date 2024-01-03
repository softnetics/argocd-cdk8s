FROM quay.io/argoproj/argocd:v2.9.3

# Switch to root for the ability to perform install
USER root

RUN apt-get update

# Setup non-root user
WORKDIR /home/argocd

# Install curl to download tools
RUN apt-get install -y curl

# Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install yarn and pnpm
RUN npm install -g yarn pnpm

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

# Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# Grant permissions to argocd user in ~/.config
RUN mkdir -p /home/argocd/.config
RUN chown -R argocd:argocd /home/argocd/.config

# Switch back to non-root user
USER 999
