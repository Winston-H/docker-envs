FROM ubuntu:18.04


ARG PASSWORD_root=kietaev4aeb4Acus
ARG SSH_KEY_root
ARG GID_boya=117640
ARG GID_boya_market=117641
ARG UID_boya_market=276591
ARG PASSWORD_boya_market=thu4Aefiexei3nai
ARG GID_boya_sip=117642
ARG UID_boya_sip=276592
ARG PASSWORD_boya_sip=oovahed4yooyagh4


ENV GO_VERSION=1.12.7
ENV NODEJS_VERSION_MAJOR=12


USER root


#
# prepare base OS and tools
#
RUN true \
 && export DEBIAN_FRONTEND="noninteractive" \
 && sed -i -e 's,//\(archive.ubuntu.com\),//cn.\1,g' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y \
        apt-utils \
        bzip2 \
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
 && export DEBIAN_FRONTEND="noninteractive" \
 && GO_INSTALLER_URL_PREFIX="https://dl.google.com/go/" \
 && GO_INSTALLER="go${GO_VERSION}.linux-amd64.tar.gz" \
 && curl -fsSLO ${GO_INSTALLER_URL_PREFIX}${GO_INSTALLER} \
 && tar -xzf ${GO_INSTALLER} -C /usr/local/ \
 && rm -f ${GO_INSTALLER} \
 && echo 'export PATH=$PATH:/usr/local/go/bin' >/etc/profile.d/golang.sh \
 && true


#
# prepare Node.js env.
#
# NOTE:
# * take long time to download and install. be patient.
#
RUN true \
 && export DEBIAN_FRONTEND="noninteractive" \
 && NODEJS_INSTALLER_URL_PREFIX="https://deb.nodesource.com/" \
 && NODEJS_INSTALLER="setup_${NODEJS_VERSION_MAJOR}.x" \
 && curl -fsSL ${NODEJS_INSTALLER_URL_PREFIX}${NODEJS_INSTALLER} | sudo -E bash - \
 && rm -f ${NODEJS_INSTALLER} \
 && apt-get install -y nodejs \
 && npm install --global \
        apidoc \
        rimraf \
        cross-env \
        cnpm \
 && true


#
# install anaconda
#
# NOTE:
# * take long time to download and install. be patient.
#
RUN true \
 && export DEBIAN_FRONTEND="noninteractive" \
 && CONDA_INSTALLER_URL_PREFIX="https://repo.continuum.io/miniconda/" \
 && CONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh" \
 && curl -fsSLO ${CONDA_INSTALLER_URL_PREFIX}${CONDA_INSTALLER} \
 && conda_install_home="/opt/anaconda3" \
 && bash ${CONDA_INSTALLER} -b -p ${conda_install_home} \
 && rm -f ${CONDA_INSTALLER} \
 && ln -s ${conda_install_home}/etc/profile.d/conda.sh /etc/profile.d/ \
 && true


#
# prepare user dev env.
#
RUN true \
 && echo "root:${PASSWORD_root}" | chpasswd \
 && if [ -n "${SSH_KEY_root}" ]; then \
        mkdir -p ~root/.ssh \
     && chmod go-rwx ~root/.ssh \
     && echo "${SSH_KEY_root}" >> ~root/.ssh/authorized_keys \
     && true; \
    fi \
 && sed -i -e 's/^ *\(PermitRootLogin\) .*$/\1 prohibit-password/g' /etc/ssh/sshd_config \
 && groupadd -g ${GID_boya} boya \
 && groupadd -g ${GID_boya_market} boya_market \
 && useradd -u ${UID_boya_market} -g boya_market -G sudo,boya -s /bin/bash -c "Boya market dev" -m boya_market \
 && echo "boya_market:${PASSWORD_boya_market}" | chpasswd \
 && groupadd -g ${GID_boya_sip} boya_sip \
 && useradd -u ${UID_boya_sip} -g boya_sip -G sudo,boya -s /bin/bash -c "Boya GB28181 dev" -m boya_sip \
 && echo "boya_sip:${PASSWORD_boya_sip}" | chpasswd \
 && true


ENTRYPOINT /etc/init.d/ssh start -D
