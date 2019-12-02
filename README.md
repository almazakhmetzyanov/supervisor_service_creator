# supervisor_service_creator
Simple script for basic supervisor service creating

This script creates new supervisor service(conf file, log files and then restart supervisor. Arguments:

# Required: 
-sn="" --service-name="" name of service. <br/>
-rc="" --running-command="" running service command <br/>
-d="" --directory="" service directory <br/>
# Not required
-u="" --user="" user. Default: root <br/>
-eld="" --err-logfile-dir="" error logfile directory. Default: /var/log/service_name/err_service_name.log <br/>
-sld="" --stdout-logfile-dir="" stdout logfile directory. Default: /var/log/service_name/stdout_service_name.log <br/>

Double quotes is important!

# example:
sh ./ssc.sh -sn="service_name" -rc="python python.py" -d="some/path/" -u="my_lover" -eld="path/to/log/file.log" -slt="path/to/log/file.log"
