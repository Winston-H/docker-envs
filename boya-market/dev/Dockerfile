FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04


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
 && echo "Install dev tools and libs" \
 && echo "Asia/Shanghai" > /etc/timezone \
 && apt-get install -y \
        apt-utils \
        build-essential \
        bzip2 \
        cmake \
        curl \
        dnsutils \
        git \
        iproute2 \
        iputils-ping \
        iputils-tracepath \
        locales \
        locales-all \
        mosh \
        net-tools \
        nginx \
        nmap \
        nmon \
        openssh-server \
        patchelf \
        rsync \
        screen \
        sudo \
        tcpdump \
        tmux \
        tzdata \
        vim \
        wget \
 && echo "Install Darwin sys deps" \
 && apt-get install -y \
        libgl1-mesa-glx \
        munge \
        slurm-wlm \
 && apt-get clean \
 && true


#
# prepare GO language env.
#
# NOTE:
# * take long time to download, be patient.
#
RUN true \
 && export DEBIAN_FRONTEND="noninteractive" \
 && true GO_INSTALLER_URL_PREFIX="https://dl.google.com/go/" \
 && GO_INSTALLER_URL_PREFIX="https://studygolang.com/dl/golang/" \
 && GO_INSTALLER="go${GO_VERSION}.linux-amd64.tar.gz" \
 && curl -fSLO ${GO_INSTALLER_URL_PREFIX}${GO_INSTALLER} \
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
 && curl -fSL ${NODEJS_INSTALLER_URL_PREFIX}${NODEJS_INSTALLER} | sudo -E bash - \
 && rm -f ${NODEJS_INSTALLER} \
 && apt-get install -y nodejs \
 && npm install --global \
        apidoc \
        cnpm \
        cross-env \
        mkdirp \
        rimraf \
 && apt-get clean \
 && true


#
# install anaconda
#
# NOTE:
# * take long time to download and install. be patient.
#
RUN true \
 && export DEBIAN_FRONTEND="noninteractive" \
 && true CONDA_INSTALLER_URL_PREFIX="https://repo.continuum.io/miniconda/" \
 && CONDA_INSTALLER_URL_PREFIX="https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/" \
 && CONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh" \
 && curl -fSLO ${CONDA_INSTALLER_URL_PREFIX}${CONDA_INSTALLER} \
 && conda_install_home="/opt/anaconda3" \
 && bash ${CONDA_INSTALLER} -b -p ${conda_install_home} \
 && rm -f ${CONDA_INSTALLER} \
 && ln -s ${conda_install_home}/etc/profile.d/conda.sh /etc/profile.d/ \
 && apt-get clean \
 && true


#
# prepare user dev env.
#
RUN true \
 && echo "root:${PASSWORD_root}" | chpasswd \
 && if [ -n "${SSH_KEY_root}" ]; then \
        mkdir -p ~root/.ssh \
     && chmod go-rwx ~root/.ssh \
     && echo "${SSH_KEY_root}" | sed -e 's/^"//g' -e 's/"$//g' >> ~root/.ssh/authorized_keys \
     && true; \
    fi \
 && sed -i -e 's/^#\? *\(PermitRootLogin\) .*$/\1 prohibit-password/g' /etc/ssh/sshd_config \
 && groupadd -g ${GID_boya} boya \
 && groupadd -g ${GID_boya_market} boya_market \
 && useradd -u ${UID_boya_market} -g boya_market -G sudo,boya -s /bin/bash -c "Boya market dev" -m boya_market \
 && echo "boya_market:${PASSWORD_boya_market}" | chpasswd \
 && groupadd -g ${GID_boya_sip} boya_sip \
 && useradd -u ${UID_boya_sip} -g boya_sip -G sudo,boya -s /bin/bash -c "Boya GB28181 dev" -m boya_sip \
 && echo "boya_sip:${PASSWORD_boya_sip}" | chpasswd \
 && true
