#! /usr/bin/env bash


USER=fuzhiwen
USER_C="Zhiwen Fu"
UID=320437
GID=537693
HOSTNAME_s=`hostname -s`

# 创建用户组
if ! getent group fuzhiwen; then
    groupadd -g $GID fuzhiwen
fi && \
# 创建用户
if ! getent passwd fuzhiwen; then
    useradd -u $UID -g fuzhiwen -G sudo,adm -s /bin/bash -c "Zhiwen Fu" -m fuzhiwen
fi && \
# 创建.ssh无密码认证
if [ ! -d ~fuzhiwen/.ssh ]; then
    sudo -u fuzhiwen -n bash -c "mkdir ~fuzhiwen/.ssh && chmod go-rwx ~fuzhiwen/.ssh"
fi && \
# 添加公钥1
if ! grep -sq buBwaQV4qa1X5IzkST0lEFyejqn ~fuzhiwen/.ssh/authorized_keys; then
    {
        # fuzhiwen@aliceworld
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUSgSae50ZzJtBexFMDloqvrYxR2uRMAV82lEFN0Ff8dpEieSHGscfIxIXO1uxBg/+X66xQszb8kvkekadArMXDlZxLc1jT5E2tItJocaZODci+xnWR8XfdeTfSjJ+7TNyY22uRX3hOaT/ACTnKQ4grWGzlf+D29oTsXKefIKkEziNF9kye/k3TBmntetDCAcYDbuBwaQV4qa1X5IzkST0lEFyejqngj8iu1c8Sf4JbpCTgm4XkteVsly2ds9cvZEp5JUtwOri2BMue9gkz9Hm/nTgsV5OvxD8bxyNGnkAlw9FVxrBTeW8N2EY1DIcGpaD7vDaeylmu6Pt47Aa59VJfbaP3qw0v7x+auITkfA0UBC+02Rb33TbZRu1mYHUk0qPySeCkrBMeQlXhu7TGcdSgzsYkJWWxlYvy+Dmn/VRMGl/Z18kOftsxX34fp5Dd83/mux1zTLJfjRHznqDLhWlGkLNIbQpjAtHCThUuY1tJ1o3+cSUd2+zoWrsTBa93HNddi45Y/OFqv3udHVkwaZFSVlanej2pTm5VemtsNjQkR8vav2ntgsTqLrBJOThgs5P5yQynCmsR9BdaeFmxz4U7ZjkUX/ufeMvLx81pLOrMKBIlB/kp0VodYVq20dRYDXif3JapBlGJJgFihNkU7z7s7CiTKZkIGr+OH1mXO1MTQ== /Users/fuzhiwen/.ssh/fuzhiwen@aliceneworld/id_rsa"
   } >> ~fuzhiwen/.ssh/authorized_keys
fi && \
# 添加公钥2
if ! grep -sq sNnFc8Wm9VoEuAwv4FQE ~fuzhiwen/.ssh/authorized_keys; then
    {
        # fuzhiwen@bladesk1
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrMpLIRC338AkTChoskYLPjjN/LikxSdutXrgsNnFc8Wm9VoEuAwv4FQE6Rr/uQUIsJPjgFgRveYQDUbRfZpSsKRgz1MrP/eYOSX05oJP0fOX9HNqZzPbQAK2tu8DzCOEpAhqOThRMPnKxWH3JXSNf//MrlGaq6GWr8s/gUJV8r2J3ttCosmexUnIWOx4lWmdBwPBVixWqd+otWnoQi/YqSv2JLlbz/V6PzWhsDedLYPF4iZq49Dp5g+JcWLi98RiwJ4F3PbaUVWEOWrfy73IHmSBLnliH5n+Un8XxJpMpAnRnxhF14gqGs/ZeaBJVH8xNkaIWvgnukNTT6sVAvrLB fuzhiwen@blapad2"
   } >> ~fuzhiwen/.ssh/authorized_keys
fi && \
# 设置sudo访问
if [ ! -f /etc/sudoers.d/fuzhiwen ]; then
    {
        echo 'Defaults:fuzhiwen !requiretty'
        echo 'fuzhiwen ALL=(ALL) NOPASSWD:ALL'
    } > /etc/sudoers.d/fuzhiwen
fi && \
# 验证sudo可以用了
sudo -i -u fuzhiwen -n bash -c "sudo -i -n whoami" && \
# 设置hosts的主entry
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
# 验证hosts的主entry
getent hosts $HOSTNAME_s && \
true
