FROM ubuntu:18.04

ARG USERNAME

RUN set -xe \
    && apt-get update  \
    && apt-get -y install apt-transport-https \
         ca-certificates \
         curl \
         gnupg2 \
         software-properties-common \
    && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey \
    && add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
       $(lsb_release -cs) \
       stable" \
    && apt-get update \
    && apt-get -y install \
        docker-ce \
        git \
        sshpass \
        dos2unix \
        zsh \
        curl \
        xclip \
        vim \
        wget \
        sudo \
        # dev
        python3-pip \
        # java
        default-jre default-jdk maven \
        # golang
        golang \
        # python libs
    && pip3 install awscli \
    # clean everything
    && apt-get clean  \
    && apt-get autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/cache/* \
    rm -rf /var/lib/log/*

# Ensure /var/run/docker.sock has correct rights
RUN touch /var/run/docker.sock \
    && chown root:docker /var/run/docker.sock

# gloud cli
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
      && mkdir -p /usr/local/gcloud \
      && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
      && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Create dev user
RUN adduser --disabled-password --gecos '' $USERNAME
RUN adduser $USERNAME sudo
RUN adduser $USERNAME docker
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USERNAME

WORKDIR "/home/${USERNAME}/"

RUN PATH="$PATH:/usr/bin/zsh" \
    && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && echo "alias mpack='mvn package'" >> ~/.zshrc \
    && echo "alias gs='git status'" >> ~/.zshrc \
    && echo "alias gr='cd ~/my-git-repos'" >> ~/.zshrc


ENTRYPOINT ["/bin/zsh"]


#ranger autojump direnv tmux

#export GOROOT=$HOME/go
#export GOPATH=$HOME/work
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
