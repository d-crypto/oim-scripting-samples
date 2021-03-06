require 'java'
require 'xlclient'

include_class('java.lang.Exception') {|package,name| "J#{name}" }
include_class 'java.lang.System'
include_class 'java.util.HashMap'
include_class('Thor.API.tcUtilityFactory') {|package,name| "OIM#{name}"}

parentFormName = 'PPP'
childFormName = 'CCC1'
fieldPrefix = 'FFX'
newVersionLabel = 'version2'

xlclient = XLAPIClient.new
xlclient.defaultLogin

fdIntf = xlclient.getUtility('fd')

# find the parent form
formMap = HashMap.new({
    'Structure Utility.Table Name' => 'UD_' + parentFormName
})

rs = fdIntf.findForms(formMap)
rs.goToRow(0)

psdkKey = rs.getLongValue('Structure Utility.Key')
psdkActiveVersion = rs.getLongValue('Structure Utility.Active Version')

# find the child form
formMap = HashMap.new({
    'Structure Utility.Table Name' => 'UD_' + childFormName
})

rs = fdIntf.findForms(formMap)
rs.goToRow(0)

csdkKey = rs.getLongValue('Structure Utility.Key')
csdkActiveVersion = rs.getLongValue('Structure Utility.Active Version')


# add fields to child form
fdIntf.createNewVersion(csdkKey, csdkActiveVersion, newVersionLabel)
csdkNewVersion = csdkActiveVersion + 1

# add form fields
for i in (1..5)
    fieldName =  fieldPrefix + i.to_s
    sdcKey = fdIntf.addFormField(csdkKey, csdkNewVersion, fieldName, 'TextField', 'String', 50, i, '', '0', false)
    puts "Added field with key #{sdcKey} to form"
end


# activate child form
fdIntf.activateFormVersion(csdkKey, csdkNewVersion)
puts "Activated form with key #{psdkKey}"

# create new parent form version
fdIntf.createNewVersion(psdkKey, psdkActiveVersion, newVersionLabel)
psdkNewVersion = psdkActiveVersion + 1


# attach parent to child form
fdIntf.attachChildFormToParentForm(psdkKey, psdkNewVersion, csdkKey, csdkNewVersion)
puts "Attached parent and child form"


# activate parent form
fdIntf.activateFormVersion(psdkKey, psdkNewVersion)
puts "Activated form with key #{psdkKey}"


xlclient.logout
System.exit 0
