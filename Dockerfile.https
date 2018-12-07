FROM oracle/graalvm-ce:1.0.0-rc9
RUN yum  install -y java-1.8.0-openjdk-headless \
	&& update-alternatives --set java $JAVA_HOME/bin/java \
        && mv $JAVA_HOME/jre/lib/security/cacerts $JAVA_HOME/jre/lib/security/cacerts.bak \
	&& ln -s /usr/lib/jvm/jre-1.8.0/lib/security/cacerts $JAVA_HOME/jre/lib/security/cacerts

CMD tail -f /dev/null

