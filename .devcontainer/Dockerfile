ARG VARIANT=alpine-3.18
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"

RUN apk --update add \
    build-base gcompat pkgconf postgresql-client \
    libpq-dev openssl-dev readline-dev yaml-dev zlib-dev \
    ca-certificates cmake curl git gnupg graphviz jq tar tmux tzdata vim yq

# Install rbenv and ruby
USER vscode

ARG RUBY_VERSION="3.2.2"
RUN git clone https://github.com/rbenv/rbenv.git /home/vscode/.rbenv  \
    && echo '[ -f "/home/vscode/.rbenv/bin/rbenv" ] && eval "$(rbenv init - bash)" # rbenv' >> /home/vscode/.bashrc \
    && echo 'export PATH="$PATH:/home/vscode/.rbenv/bin"' >> /home/vscode/.bashrc \
    && mkdir -p /home/vscode/.rbenv/versions \
    && mkdir -p /home/vscode/.rbenv/plugins \
    && git clone https://github.com/rbenv/ruby-build.git /home/vscode/.rbenv/plugins/ruby-build

ENV PATH "$PATH:/home/vscode/.rbenv/bin:/home/vscode/.rbenv/shims"

RUN rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION && \
    rbenv versions

