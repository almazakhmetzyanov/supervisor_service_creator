# supervisor_service_creator
Simple script for basic supervisor service creating

This script creates new supervisor service(conf file, log files and then restart supervisor. Arguments:
# Double quotes is important!

# Required: 
-sn="" --service-name="" name of service."
-rc="" --running-command="" running service command"
-d="" --directory="" service directory"
# Not required
-u="" --user="" user. Default: root"
-eld="" --err-logfile-dir="" error logfile directory. Default: /var/log/service_name/err_service_name.log"
-sld="" --stdout-logfile-dir="" stdout logfile directory. Default: /var/log/service_name/stdout_service_name.log"
