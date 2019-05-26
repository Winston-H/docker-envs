FROM cptactionhank/atlassian-jira-software:7.12.0

#ARG AGENT_PKG=https://github.com/pengzhile/atlassian-agent/releases/download/v1.2.2/atlassian-agent-v1.2.2.tar.gz
ARG AGENT_PKG=atlassian-agent-v1.2.2.tar.gz

USER root

# 将代理破解包加入容器
#COPY "atlassian-agent.jar" /opt/atlassian/jira/
ADD $AGENT_PKG /opt/atlassian/jira
RUN cd /opt/atlassian/jira && if [ ! -f */atlassian-agent.jar ]; then tar xvf `basename $AGENT_PKG`; fi && ln -s */atlassian-agent.jar ./

# 设置启动加载代理包
RUN echo 'export CATALINA_OPTS="-javaagent:/opt/atlassian/jira/atlassian-agent.jar ${CATALINA_OPTS}"' >> /opt/atlassian/jira/bin/setenv.sh
