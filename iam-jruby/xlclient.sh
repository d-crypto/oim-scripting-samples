export JAVA_HOME=
export XLHOME=
export JRUBY_HOME=
export OIM_SERVER=
export OIM_DEPLOY=
export WL_HOME=
#export AVR=/ade/adharmad_formupg/iam
export APPSERVER_TYPE=wls

export EXT_CP="$WL_HOME/oracle_common/modules/oracle.jrf_11.1.1/jrf-api.jar:$WL_HOME/oracle_common/modules/oracle.jps_11.1.1/jps-unsupported-api.jar:$WL_HOME/oracle_common/modules/oracle.jps_11.1.1/jps-api.jar:$WL_HOME/oracle_common/modules/oracle.jps_11.1.1/jps-common.jar:$WL_HOME/oracle_common/modules/oracle.jps_11.1.1/jps-internal.jar"

export CLASSPATH="$OIM_SERVER/ext/internal/eclipselink.jar:$OIM_SERVER/platform/iam-platform-authopss-service.jar:$OIM_SERVER/platform/iam-platform-entitymgr.jar:$OIM_SERVER/platform/iam-platform-authz-service.jar:$XLHOME/lib/oimclient.jar:$XLHOME/lib/iam-platform-auth-client.jar:$XLHOME/lib/iam-platform-utils.jar:$XLHOME/lib/iam-platform-context.jar:$XLHOME/lib/iam-platform-pluginframework.jar:$XLHOME/ext/spring.jar:$XLHOME/ext/logging-utils.jar:$XLHOME/ext/log4j-1.2.8.jar:$XLHOME/lib/xlAPI.jar:$XLHOME/lib/xlLogger.jar:$XLHOME/lib/xlVO.jar:$XLHOME/lib/xlUtils.jar:$XLHOME/lib/xlCrypto.jar:$XLHOME/lib/xlAuthentication.jar:$XLHOME/lib/xlDataObjectBeans.jar:$XLHOME/ext/wlfullclient.jar:$XLHOME/ext/oscache.jar:$XLHOME/ext/commons-logging.jar:$XLHOME/ext/javagroups-all.jar:$EXT_CP"
#:$OIM_DEPLOY/APP-INF/lib/OIMServer.jar:$EXT_CP"
echo $CLASSPATH

export JAVA_OPTS="-DXL.HomeDir=$XLHOME -Djava.security.auth.login.config=$XLHOME/config/authwl.conf"

$JRUBY_HOME/bin/jruby $*
