#!/bin/sh
#
SCRIPTDIR=$(cd $(dirname $0) && pwd)
PKGDIR=$(dirname $SCRIPTDIR)
source $PKGDIR/lib/libcommon.sh
MODE="init"
SERVICES="data,index,query"
INDEX_MEM_OPT="default"
NODE_NUMBER=1
PRINT_USAGE="Usage: $0 -m | -i | -s
             -m Mode
             -i Cluster host
             -s Services"

while getopts "m:i:e:s:o:r:" opt
do
  case $opt in
    m)
      MODE=$OPTARG
      ;;
    i)
      INTERNAL_IP=$OPTARG
      ;;
    e)
      EXTERNAL_IP=$OPTARG
      ;;
    s)
      SERVICES=$OPTARG
      ;;
    o)
      INDEX_MEM_OPT=$OPTARG
      ;;
    r)
      RALLY_NODE=$OPTARG
      ;;
    \?)
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ "$(id -u)" -ne 0 ]; then
  err_exit "You must run this utility as root."
fi

case $MODE in
  config)
    cb_node_setup
    ;;
  remove)
    cb_node_remove
    ;;
  write)
    cb_write_node_config
    ;;
  debug)
    cb_init_debug
    ;;
  *)
    err_exit "Unknown mode $MODE"
    ;;
esac