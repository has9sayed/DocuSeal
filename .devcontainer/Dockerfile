FROM mcr.microsoft.com/devcontainers/ruby:3.2

   # Install additional OS packages
   RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
       && apt-get -y install --no-install-recommends \
       postgresql-client \
       libpq-dev \
       && apt-get clean \
       && rm -rf /var/lib/apt/lists/*

   # Install specific Ruby version
   RUN gem install bundler
