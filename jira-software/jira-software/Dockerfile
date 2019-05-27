FROM cptactionhank/atlassian-jira-software:8.1.0

#ARG AGENT_PKG=https://github.com/pengzhile/atlassian-agent/releases/download/v1.2.2/atlassian-agent-v1.2.2.tar.gz
ARG AGENT_PKG=atlassian-agent-v1.2.2.tar.gz
ARG MYSQL_C_PKG=https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz

USER root

# 将代理破解包加入容器
#COPY "atlassian-agent.jar" /opt/atlassian/jira/
ADD $AGENT_PKG /opt/atlassian/jira
RUN cd /opt/atlassian/jira && if [ ! -f */atlassian-agent.jar ]; then tar xvf `basename $AGENT_PKG`; fi && ln -s */atlassian-agent.jar ./

# update mysql-connector
#ADD $AGENT_PKG /opt/atlassian/jira
#RUN cd /opt/atlassian/jira && if [ ! -f */mysql-connector-java-5.1.47-bin.jar ]; then tar xvf `basename $MYSQL_C_PKG`; fi && cd lib && ln -s ../*/mysql-connector-java-5.1.47-bin.jar ./

# 设置启动加载代理包
RUN echo 'export CATALINA_OPTS="-javaagent:/opt/atlassian/jira/atlassian-agent.jar ${CATALINA_OPTS}"' >> /opt/atlassian/jira/bin/setenv.sh
