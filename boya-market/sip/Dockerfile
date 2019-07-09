FROM ubuntu:18.04

USER root

RUN true \
    sed -i -e 's,//\(archive.ubuntu.com\),//cn.\1,g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        openssh-server \
        rsync \
        screen \
        sudo \
        tmux \
        vim && \
    true

RUN true \
    echo "root:kietaev4aeb4Acus" | chpasswd && \
    groupadd -g 117640 boya && \
    groupadd -g 117641 boya_market && \
    useradd -u 276591 -g boya_market -G sudo,boya -s /bin/bash -c "Boya market dev" -m boya_market && \
    echo "boya_market:thu4Aefiexei3nai" | chpasswd && \
    groupadd -g 117642 boya_sip && \
    useradd -u 276592 -g boya_sip -G sudo,boya -s /bin/bash -c "Boya GB28181 dev" -m boya_sip && \
    echo "boya_sip:oovahed4yooyagh4" | chpasswd && \
    true

ENTRYPOINT /etc/init.d/ssh start -D
