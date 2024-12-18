FROM mcr.microsoft.com/devcontainers/ruby:3.2

# Install PostgreSQL client and development packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client libpq-dev \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler

# Create app directory
RUN mkdir -p /workspaces/DocuSeal
WORKDIR /workspaces/DocuSeal
