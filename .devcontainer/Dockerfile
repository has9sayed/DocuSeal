FROM mcr.microsoft.com/devcontainers/ruby:3.2

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    postgresql-client \
    libpq-dev \
    nodejs \
    npm \
    git \
    curl \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install specific Ruby version and bundler
RUN gem install bundler

# Create workspace directory
RUN mkdir -p /workspaces/DocuSeal

WORKDIR /workspaces/DocuSeal
