FROM ruby:2.7.6-bullseye

RUN apt update && \
    apt install -y zsh fish default-mysql-client

# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && \
    apt install -y gh

# https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws awscliv2.zip

# https://github.com/microsoft/vscode-dev-containers/blob/ac0a5435d69119d9a3dccfb7be10b1e84f4f8379/script-library/docs/docker-in-docker.md
ENV DOCKER_BUILDKIT=1
RUN curl -LO https://raw.githubusercontent.com/microsoft/vscode-dev-containers/7a4ef23f4034e2f7ded0d2a306561f36677ced9d/script-library/docker-in-docker-debian.sh && \
  /bin/bash ./docker-in-docker-debian.sh && rm -f docker-in-docker-debian.sh

COPY Gemfile .
COPY Gemfile.lock .
RUN gem install bundler:2.3.5 && \
    bundle install && \
    rm -f Gemfile Gemfile.lock

ENTRYPOINT ["/usr/local/share/docker-init.sh"]
VOLUME [ "/var/lib/docker" ]
CMD ["sleep", "infinity"]
