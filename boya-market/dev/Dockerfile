FROM ubuntu:18.04


ENV GO_VERSION=1.12.7
ENV GO_INSTALLER_URL_PREFIX=https://dl.google.com/go/

ENV NODEJS_VERSION_MAJOR=12
ENV NODEJS_INSTALLER_URL_PREFIX=https://deb.nodesource.com/


USER root


#
# prepare base OS and tools
#
RUN true \
 && sed -i -e 's,//\(archive.ubuntu.com\),//cn.\1,g' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y \
        apt-utils \
        build-essential \
        curl \
        openssh-server \
        rsync \
        screen \
        sudo \
        tmux \
        vim \
        wget \
 && true


#
# prepare GO language env.
#
# NOTE:
# * take long time to download, be patient.
#
RUN true \
 && GO_INSTALLER=go${GO_VERSION}.linux-amd64.tar.gz \
 && curl -sLO ${GO_INSTALLER_URL_PREFIX}/${GO_INSTALLER} \
 && tar -xzf ${GO_INSTALLER} -C /usr/local/ \
 && echo 'export PATH=$PATH:/usr/local/go/bin' >/etc/profile.d/golang.sh \
 && true


#
# prepare Node.js env.
#
# NOTE:
# * take long time to download and install. be patient.
#
RUN true \
 && curl -sL ${NODEJS_INSTALLER_URL_PREFIX}/setup_${NODEJS_VERSION_MAJOR}.x | sudo -E bash - \
 && apt-get install -y nodejs \
 && npm install --global \
        apidoc \
        rimraf \
        cross-env \
        cnpm \
 && true


#
# prepare user dev env.
#
RUN true \
 && echo "root:kietaev4aeb4Acus" | chpasswd \
 && groupadd -g 117640 boya \
 && groupadd -g 117641 boya_market \
 && useradd -u 276591 -g boya_market -G sudo,boya -s /bin/bash -c "Boya market dev" -m boya_market \
 && echo "boya_market:thu4Aefiexei3nai" | chpasswd \
 && groupadd -g 117642 boya_sip \
 && useradd -u 276592 -g boya_sip -G sudo,boya -s /bin/bash -c "Boya GB28181 dev" -m boya_sip \
 && echo "boya_sip:oovahed4yooyagh4" | chpasswd \
 && true

ENTRYPOINT /etc/init.d/ssh start -D
