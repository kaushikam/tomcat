#!/bin/sh

export CATALINA_HOME=/opt/tomcat
export CATALINA_BASE=$CATALINA_HOME
export CATALINA_OPTS='-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
export CATALINA_PID=$CATALINA_HOME/temp/tomcat.pid
export JAVA_OPTS='-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

DIR=${DEPLOY_DIR:-/webapps}
echo "Checking *.war in $DIR"
if [ -d $DIR ]; then
  for i in $DIR/*.war; do
     file=$(basename $i)
     echo "Linking $i --> ${CATALINA_HOME}/webapps/$file"
     ln -s $i ${CATALINA_HOME}/webapps/$file
  done
fi

DIR=${LIBS_DIR:-/lib}
echo "Checking tomcat extended libs *.jar in $DIR"
if [ -d $DIR ]; then
  for i in $DIR/*.jar; do
     file=$(basename $i)
     echo "Linking $i --> ${CATALINA_HOME}/lib/$file"
     ln -s $i ${CATALINA_HOME}/lib/$file
  done
fi

# Autorestart possible?
#-XX:OnError="cmd args; cmd args"
#-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/heapdump.hprof -XX:OnOutOfMemoryError="sh ~/cleanup.sh"

exec ${CATALINA_HOME}/bin/catalina.sh run