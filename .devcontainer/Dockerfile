ARG VARIANT="3.0"
FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-${VARIANT}

ARG CHEF_VERSION=18.0.92
ARG BAT_VERSION=0.21.0
ARG DIRENV_VERSION=2.32.1
ARG GLOW_VERSION=1.4.1

#RUN gem install aws-sdk erubis

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends jq vim direnv yamllint python3-pip python3-setuptools git less python3-dev

COPY requirements.txt /tmp/
RUN pip3 install --requirement /tmp/requirements.txt

RUN curl --location-trusted https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_linux_x86_64.tar.gz --output /tmp/glow.tgz --silent \
    && tar zxf /tmp/glow.tgz \
    && mv glow /usr/local/bin \
    && rm LICENSE README.md \
    && rm /tmp/glow.tgz

RUN curl --location-trusted https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz --output /tmp/bat_${BAT_VERSION}_x86_64-musl.tgz --silent \
   && tar zxvf /tmp/bat_${BAT_VERSION}_x86_64-musl.tgz \
   && mv bat-v${BAT_VERSION}-x86_64-unknown-linux-musl/bat /usr/local/bin \
   && rm -r bat-v${BAT_VERSION}-x86_64-unknown-linux-musl \
   && rm /tmp/bat_${BAT_VERSION}_x86_64-musl.tgz

RUN curl --location-trusted https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64 --output /usr/local/bin/direnv --silent \
    && chmod +x /usr/local/bin/direnv

RUN curl --location-trusted https://packages.chef.io/files/current/chef/${CHEF_VERSION}/ubuntu/20.04/chef_${CHEF_VERSION}-1_amd64.deb --output /tmp/chef_${CHEF_VERSION}.deb --silent \
    && dpkg --install /tmp/chef_${CHEF_VERSION}.deb \
    && rm /tmp/chef_${CHEF_VERSION}.deb

RUN echo -e "setlocal noautoindent\nsetlocal nocindent\nsetlocal nosmartindent\nsetlocal indentexpr=\"\n" > /home/${USER}/.vimrc \
    && echo 'alias awsume="source awsume"' >> /home/${USER}/.bashrc \
    && echo 'eval "$(direnv hook bash)"' >> /home/${USER}/.bashrc \
    && mkdir /home/${USER}/.aws
