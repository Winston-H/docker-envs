#! /usr/bin/env bash


USER=fuzhiwen
GROUP=fuzhiwen
USER_c="Zhiwen Fu"
UID=320437
GID=537693

HOSTNAME_s=`hostname -s`

SHARE_ROOT=/workspace/share
SHARE_ROOT_REAL=/workspace/storage

HDD_ROOT=/workspace/hdd
HDD_ROOT_REAL=/root/data


#
# 创建用户组
#
if ! getent group $GROUP >/dev/null 2>&1; then
    groupadd -g $GID $GROUP
fi && \
# 显示验证用户组信息
getent group $GROUP && \
#
# 创建用户
#
if ! getent passwd $USER >/dev/null 2>&1; then
    useradd -u $UID -g $GROUP -G sudo,adm -s /bin/bash -c "$USER_c" -m $USER
fi && \
# 显示验证用户信息
getent passwd $USER && \
USER_HOME=`getent passwd $USER | cut -d: -f6`
#
# 创建.ssh无密码认证
#
for _USER in root $USER boya_market boya_sip
do
    _USER_HOME=`getent passwd $_USER | cut -d: -f6`
    if [ ! -d $_USER_HOME/.ssh ]; then
        sudo -u $_USER -n bash -c "mkdir $_USER_HOME/.ssh && chmod go-rwx $_USER_HOME/.ssh"
    fi && \
    # 添加公钥1
    if ! grep -sq buBwaQV4qa1X5IzkST0lEFyejqn $_USER_HOME/.ssh/authorized_keys; then
        {
            # $USER@aliceworld
            echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUSgSae50ZzJtBexFMDloqvrYxR2uRMAV82lEFN0Ff8dpEieSHGscfIxIXO1uxBg/+X66xQszb8kvkekadArMXDlZxLc1jT5E2tItJocaZODci+xnWR8XfdeTfSjJ+7TNyY22uRX3hOaT/ACTnKQ4grWGzlf+D29oTsXKefIKkEziNF9kye/k3TBmntetDCAcYDbuBwaQV4qa1X5IzkST0lEFyejqngj8iu1c8Sf4JbpCTgm4XkteVsly2ds9cvZEp5JUtwOri2BMue9gkz9Hm/nTgsV5OvxD8bxyNGnkAlw9FVxrBTeW8N2EY1DIcGpaD7vDaeylmu6Pt47Aa59VJfbaP3qw0v7x+auITkfA0UBC+02Rb33TbZRu1mYHUk0qPySeCkrBMeQlXhu7TGcdSgzsYkJWWxlYvy+Dmn/VRMGl/Z18kOftsxX34fp5Dd83/mux1zTLJfjRHznqDLhWlGkLNIbQpjAtHCThUuY1tJ1o3+cSUd2+zoWrsTBa93HNddi45Y/OFqv3udHVkwaZFSVlanej2pTm5VemtsNjQkR8vav2ntgsTqLrBJOThgs5P5yQynCmsR9BdaeFmxz4U7ZjkUX/ufeMvLx81pLOrMKBIlB/kp0VodYVq20dRYDXif3JapBlGJJgFihNkU7z7s7CiTKZkIGr+OH1mXO1MTQ== $USER@aliceneworld/id_rsa"
        } >> $_USER_HOME/.ssh/authorized_keys
    fi && \
    # 添加公钥2
    if ! grep -sq sNnFc8Wm9VoEuAwv4FQE $_USER_HOME/.ssh/authorized_keys; then
        {
            # $USER@bladesk1
            echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrMpLIRC338AkTChoskYLPjjN/LikxSdutXrgsNnFc8Wm9VoEuAwv4FQE6Rr/uQUIsJPjgFgRveYQDUbRfZpSsKRgz1MrP/eYOSX05oJP0fOX9HNqZzPbQAK2tu8DzCOEpAhqOThRMPnKxWH3JXSNf//MrlGaq6GWr8s/gUJV8r2J3ttCosmexUnIWOx4lWmdBwPBVixWqd+otWnoQi/YqSv2JLlbz/V6PzWhsDedLYPF4iZq49Dp5g+JcWLi98RiwJ4F3PbaUVWEOWrfy73IHmSBLnliH5n+Un8XxJpMpAnRnxhF14gqGs/ZeaBJVH8xNkaIWvgnukNTT6sVAvrLB $USER@blapad2"
        } >> $_USER_HOME/.ssh/authorized_keys
    fi

    if [ $? -ne 0 ]; then
	false
	break
    fi
done && \
#
# 设置sudo访问
#
if [ ! -f /etc/sudoers.d/$USER ]; then
    {
        echo 'Defaults:'"$USER"' !requiretty'
        echo "$USER"' ALL=(ALL) NOPASSWD:ALL'
    } > /etc/sudoers.d/$USER
fi && \
# 验证sudo可以用了
sudo -i -u $USER -n bash -c "sudo -i -n whoami" && \
#
# 设置hosts的主entry
#
if ! getent hosts $HOSTNAME_s | grep -sq $HOSTNAME_s; then
    GW_IPADDR=`ip route get 8.8.8.8 | grep "^8.8.8.8 .*via.*src" | sed -e 's/^.*src *//g' | sed -e 's/ //g'`
    if grep -sqF "$GW_IPADDR" /etc/hosts; then
	ftmp=`mktemp /tmp/XXXX` && \
	sed -e "s/^ *${GW_IPADDR}.*/${GW_IPADDR} ${HOSTNAME_s}/g" /etc/hosts >$ftmp && \
	cat $ftmp | tee /etc/hosts && \
	rm -f $ftmp
    else
        echo "$GW_IPADDR $HOSTNAME_s" >> /etc/hosts
    fi
fi && \
# 验证显示hosts的主entry
getent hosts $HOSTNAME_s && \
#
# 设置SHARE_ROOT
#
if [ ! -d $SHARE_ROOT ]; then
    ln -s $SHARE_ROOT_REAL $SHARE_ROOT
fi && \
ls -ld $SHARE_ROOT && \
#
# 设置SHARE_ROOT上的HOME
#
if [ ! -d $SHARE_ROOT/home ]; then
    mkdir $SHARE_ROOT/home
fi && \
# 由于NFS服务器上设置了root_squash，只能777了
chmod 777 $SHARE_ROOT/home && \
ls -ld $SHARE_ROOT/home && \
#
if [ ! -d $SHARE_ROOT/home/$USER ]; then
    sudo -u $USER -n mkdir $SHARE_ROOT/home/$USER
fi && \
ls -ld $SHARE_ROOT/home/$USER && \
sudo -u $USER -n ls -ld $SHARE_ROOT/home/$USER && \
#
if [ ! -d $SHARE_ROOT/home/boya_market ]; then
    sudo -u boya_market -n mkdir $SHARE_ROOT/home/boya_market
fi && \
ls -ld $SHARE_ROOT/home/boya_market && \
sudo -u boya_market -n ls -ld $SHARE_ROOT/home/boya_market && \
#
if [ ! -d $SHARE_ROOT/home/boya_sip ]; then
    sudo -u boya_sip -n mkdir $SHARE_ROOT/home/boya_sip
fi && \
ls -ld $SHARE_ROOT/home/boya_sip && \
sudo -u boya_sip -n ls -ld $SHARE_ROOT/home/boya_sip && \
#
# 设置HDD_ROOT
#
if [ ! -d $HDD_ROOT ]; then
    chmod a+rx $HDD_ROOT_REAL && \
    ln -s $HDD_ROOT_REAL $HDD_ROOT
fi && \
ls -ld $HDD_ROOT && \
#
# 设置HDD_ROOT上的HOME
#
if [ ! -d $HDD_ROOT/home ]; then
    mkdir $HDD_ROOT/home
fi && \
# 由于NFS服务器上设置了root_squash，只能777了
chmod 777 $HDD_ROOT/home && \
ls -ld $HDD_ROOT/home && \
#
if [ ! -d $HDD_ROOT/home/$USER ]; then
    sudo -u $USER -n mkdir $HDD_ROOT/home/$USER
fi && \
ls -ld $HDD_ROOT/home/$USER && \
sudo -u $USER -n ls -ld $HDD_ROOT/home/$USER && \
#
if [ ! -d $HDD_ROOT/home/boya_market ]; then
    sudo -u boya_market -n mkdir $HDD_ROOT/home/boya_market
fi && \
ls -ld $HDD_ROOT/home/boya_market && \
sudo -u boya_market -n ls -ld $HDD_ROOT/home/boya_market && \
#
if [ ! -d $HDD_ROOT/home/boya_sip ]; then
    sudo -u boya_sip -n mkdir $HDD_ROOT/home/boya_sip
fi && \
ls -ld $HDD_ROOT/home/boya_sip && \
sudo -u boya_sip -n ls -ld $HDD_ROOT/home/boya_sip && \
#
# 设置conda
#
for _USER in $USER boya_market boya_sip
do
    sudo -u $_USER -n -i bash -c "conda config --append envs_dirs $SHARE_ROOT/.conda/envs" &&
    sudo -u $_USER -n -i bash -c "conda config --append pkgs_dirs $SHARE_ROOT/.conda/pkgs"
    if [ $? -ne 0 ]; then
	false
	break
    fi
    sudo -u $_USER -n -i cat .condarc | sed -e 's/^/[conda rc] >> /g' >&1
done && \
#
# 尾部
#
true
