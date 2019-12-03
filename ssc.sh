#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

#parsing arguments
args="-sn -rc -d -u -eld -sld --service-name --running-command --directory --err-logfile-dir --stdout-logfile-dir --help"
arg_array=("$args")
for i in "$@"; do
  for ob in ${arg_array[*]}; do
    if [[ $i == $ob* ]]; then
      is_arg_valid=true
      continue
    fi
  done
  if [[ $is_arg_valid != true ]]; then
    echo -e "${RED}Unexpected argument: ${NC}" $i
    echo -e "This script creates prepared supervisor conf file. Arguments: "
    echo -e "${GREEN}Double quotes is important! ${NC}"
    echo -e "${RED}Required:${NC} -sn=\"\" --service-name=\"\" name of service."
    echo -e "${RED}Required:${NC} -rc=\"\" --running-command=\"\" running service command"
    echo -e "${RED}Required:${NC} -d=\"\" --directory=\"\" service directory"
    echo -e "-u=\"\" --user=\"\" user. Default: root"
    echo -e "-eld=\"\" --err-logfile-dir=\"\" error logfile directory. Default: /var/log/service_name/err_service_name.log"
    echo -e "-sld=\"\" --stdout-logfile-dir=\"\" stdout logfile directory. Default: /var/log/service_name/stdout_service_name.log"
    exit 0
  fi
  is_arg_valid=false
  case $i in
  -sn=*)
    SERVICE_NAME="${i#*=}"
    shift
    ;;
  -rc=*)
    RUNNING_COMMAND="${i#*=}"
    shift
    ;;
  -d=*)
    DIRECTORY="${i#*=}"
    shift
    ;;
  -eld=*)
    ERRLOGFILEDIR="${i#*=}"
    shift
    ;;
  -sld=*)
    STDLOGFILEDIR="${i#*=}"
    shift
    ;;
  -u=*)
    SERVICE_USER="${i#*=}"
    shift
    ;;
  -h)
    echo -e "This script creates new supervisor service(conf file, log files and then restart supervisor. Arguments: "
    echo -e "${GREEN}Double quotes is important! ${NC}"
    echo -e "${RED}Required:${NC} -sn=\"\" --service-name=\"\" name of service."
    echo -e "${RED}Required:${NC} -rc=\"\" --running-command=\"\" running service command"
    echo -e "${RED}Required:${NC} -d=\"\" --directory=\"\" service directory"
    echo -e "-u=\"\" --user=\"\" user. Default: root"
    echo -e "-eld=\"\" --err-logfile-dir=\"\" error logfile directory. Default: /var/log/service_name/err_service_name.log"
    echo -e "-sld=\"\" --stdout-logfile-dir=\"\" stdout logfile directory. Default: /var/log/service_name/stdout_service_name.log"
    exit 0
    ;;
  --service-name=*)
    SERVICE_NAME="${i#*=}"
    shift
    ;;
  --running-command=*)
    RUNNING_COMMAND="${i#*=}"
    shift
    ;;
  --directory=*)
    DIRECTORY="${i#*=}"
    shift
    ;;
  --err-logfile-dir=*)
    ERRLOGFILEDIR="${i#*=}"
    shift
    ;;
  --stdout-logfile-dir=*)
    STDLOGFILEDIR="${i#*=}"
    shift
    ;;
  --user=*)
    SERVICE_USER="${i#*=}"
    shift
    ;;
  --help)
    echo -e "This script creates new supervisor service(conf file, log files and then restart supervisor. Arguments: "
    echo -e "${GREEN}Double quotes is important! ${NC}"
    echo -e "${RED}Required:${NC} -sn=\"\" --service-name=\"\" name of service."
    echo -e "${RED}Required:${NC} -rc=\"\" --running-command=\"\" running service command"
    echo -e "${RED}Required:${NC} -d=\"\" --directory=\"\" service directory"
    echo -e "-u=\"\" --user=\"\" user. Default: root"
    echo -e "-eld=\"\" --err-logfile-dir=\"\" error logfile directory. Default: /var/log/service_name/err_service_name.log"
    echo -e "-sld=\"\" --stdout-logfile-dir=\"\" stdout logfile directory. Default: /var/log/service_name/stdout_service_name.log"
    exit 0
    ;;
  esac
done

if [ -z "${SERVICE_NAME}" ]; then
  echo "Missing required argument: ${RED}\"service_name\"${NC}. Please fill it: -sv=\"\" --service_name=\"\""
  exit 0
fi

if [ -z "${RUNNING_COMMAND}" ]; then
  echo "Missing required argument: ${RED}\"running_command\"${NC}. Please fill it: -rc=\"\" --running_command=\"\""
  exit 0
fi

if [ -z "${DIRECTORY}" ]; then
  echo "Missing required argument: ${RED}\"directory\"${NC}. Please fill it: -d=\"\" --directory=\"\""
  exit 0
fi

if [ -z "${ERRLOGFILEDIR}" ]; then
  ERRLOGFILEDIR=/var/log/err_"${SERVICE_NAME}".log
  echo "Created default errlogfile ${ERRLOGFILEDIR}"
    echo >"${ERRLOGFILEDIR}"
    else
    echo >"${ERRLOGFILEDIR}"
fi

if [ -z "${STDLOGFILEDIR}" ]; then
  STDLOGFILEDIR=/var/log/std_"${SERVICE_NAME}".log
  echo "Created default stdlogfile ${STDLOGFILEDIR}"
    echo >"${STDLOGFILEDIR}"
    else
    echo >"${STDLOGFILEDIR}"
fi

if [ -z "${SERVICE_USER}" ]; then
  SERVICE_USER="root"
fi

conf_template="[program:${SERVICE_NAME}]
command = ${RUNNING_COMMAND}
directory = ${DIRECTORY}
stopasgroup = true
autostart = false
autorestart = true
startretries = 3
stderr_logfile = ${ERRLOGFILEDIR}
stdout_logfile = ${STDLOGFILEDIR}
user = ${SERVICE_USER}"
echo -e "${conf_template}" >/etc/supervisor/conf.d/"${SERVICE_NAME}".conf

echo -e "Created supervisor config: "
echo -e "${conf_template}"
echo -e "Restarting supervisor..."
service supervisor restart
echo -e "Supervisor restarted."
echo -e "${GREEN}========FINISH========${NC}"
