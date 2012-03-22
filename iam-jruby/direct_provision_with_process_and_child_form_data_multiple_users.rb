require 'java'
require 'xlclient'

include_class('java.lang.Exception') {|package,name| "J#{name}" }
include_class 'java.lang.System' 
include_class 'java.util.HashMap'
include_class 'java.util.Hashtable'
include_class('Thor.API.tcUtilityFactory') {|package,name| "OIM#{name}"}

usrPrefix = 'CAVERY'
count = 10
objName = 'ro3'

parentFormName = 'UD_RO3'
childForms = ['UD_RO3C', 'UD_ANOTCHLD']

xlclient = XLAPIClient.new
xlclient.defaultLogin

usrIntf = xlclient.getUtility('usr')
fiIntf = xlclient.getUtility('fi')

for idx in (1..count)

    usrLogin = usrPrefix + idx.to_s

    usrKey = xlclient.getUsrKey(usrLogin)
    objKey = xlclient.getObjKey(objName)

    t1 = System.currentTimeMillis
    oiuKey = usrIntf.provisionObject(usrKey, objKey)

    # get the objects provisioned to the user
    rs = usrIntf.getObjects(usrKey)
    orcKey = 0
    for i in (0..rs.getRowCount-1)
        rs.goToRow i
        oiuKeyFromRS = rs.getLongValue "Users-Object Instance For User.Key"

        if oiuKeyFromRS == oiuKey
            orcKey = rs.getLongValue "Process Instance.Key"
            #puts "Got orcKey = #{orcKey}"
        end
    end

    # set process form data
    udHash = {
        parentFormName + '_SERVER' => '48',
        parentFormName + '_F1' => usrLogin + '_test_data_id_1',
        parentFormName + '_F2' => usrLogin + '_test_data_id_2',
        parentFormName + '_F3' => usrLogin + '_test_data_id_3',
        parentFormName + '_F4' => usrLogin + '_test_data_id_4',
    }

    udMap = HashMap.new(udHash)
    fiIntf.setProcessFormData(orcKey, udMap)

    # fill in child form data
    for cForm in childForms
        cFormKey = xlclient.getFormKey(cForm)

        case cForm 
        when 'UD_RO3C'
       
            # first child table entry
            udChildMap = HashMap.new({
                cForm + '_F1' => '22~code1',
                cForm + '_F2' => 'just some desc 1'
            })

            fiIntf.addProcessFormChildData(cFormKey, orcKey, udChildMap)

            # second child table entry
            udChildMap = HashMap.new({
                cForm + '_F1' => '23~code4',
                cForm + '_F2' => 'just some desc 2'
            })

            fiIntf.addProcessFormChildData(cFormKey, orcKey, udChildMap)
        
            # third child table entry
            udChildMap = HashMap.new({
                cForm + '_F1' => '26~code8',
                cForm + '_F2' => 'just some desc 3'
            })

            fiIntf.addProcessFormChildData(cFormKey, orcKey, udChildMap)
        when 'UD_ANOTCHLD'

            # first child table entry
            udChildMap = HashMap.new({
                cForm + '_ENT' => '22~code1',
                cForm + '_FOO' => 'just some desc 1'
            })

            fiIntf.addProcessFormChildData(cFormKey, orcKey, udChildMap)

            # second child table entry
            udChildMap = HashMap.new({
                cForm + '_ENT' => '23~code4',
                cForm + '_FOO' => 'just some desc 2'
            })

            fiIntf.addProcessFormChildData(cFormKey, orcKey, udChildMap)


        end
    end


    t2 = System.currentTimeMillis

    delta = t2-t1
    puts "Provisioned user with key = #{usrKey} resource oiu_key = #{oiuKey} time = #{delta}"

end

xlclient.logout
System.exit 0
