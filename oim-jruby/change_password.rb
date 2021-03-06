require 'java'
require 'xlclient'

include_class('java.lang.Exception') {|package,name| "J#{name}" }
include_class 'java.lang.System' 
include_class 'java.lang.Thread' 
include_class 'java.util.HashMap'
include_class 'java.util.Hashtable'
include_class('Thor.API.tcUtilityFactory') {|package,name| "OIM#{name}"}

usr_key = 932

xlclient = XLAPIClient.new
xlclient.defaultLogin
jndi = Hashtable.new({
    'java.naming.provider.url' => 'jnp://dadvmn0695.us.oracle.com:1099',
    'java.naming.factory.initial' => 'org.jnp.interfaces.NamingContextFactory'
})

#xlclient.signatureLogin('xelsysadm')
#xlclient.remoteLogin('xelsysadm', 'xelsysadm', jndi)

passIntf = xlclient.getUtility('pass')

t1 = System.currentTimeMillis
passIntf.setXelleratePassword(usr_key, 'foo1')
t2 = System.currentTimeMillis

delta = t2-t1
puts "Changed password"

xlclient.close
System.exit 0
