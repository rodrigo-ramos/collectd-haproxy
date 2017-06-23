 #!/bin/sh
 
 sock='/run/haproxy/admin.sock'
 host="${COLLECTD_HOSTNAME}"
 pause="${COLLECTD_INTERVAL:-10}"
 
 while getopts "h:p:s:" c; do
        case $c in
                h)      host=$OPTARG;;
                p)      pause=$OPTARG;;
                s)      sock=$OPTARG;;
                *)      echo "Usage: $0 [-h <hostname>] [-p <seconds>] [-s <sockfile>]";;
        esac
 done
 
 while [ $? -eq 0 ]; do
        time="$(date +%s)"
 echo 'show stat' | socat - UNIX-CLIENT:/run/haproxy/admin.sock | sed -e 's/#//gp' | while IFS=","; read pxname svname qcur qmax scur smax slim stot bin bout dreq dresp ereq econ eresp wretr wredis status weight act bck chkfail chkdown lastchg downtime qlimit pid iid sid throttle lbtot tracked type rate rate_lim rate_max check_status check_code check_duration hrsp_1xx hrsp_2xx hrsp_3xx hrsp_4xx hrsp_5xx hrsp_other hanafail req_rate req_rate_max req_tot cli_abrt srv_abrt comp_in comp_out comp_byp comp_rsp lastsess last_chk last_agt qtime ctime rtime ttime; do
               if [ ! -z "$svname" ]; then
                   [ "$svname" != 'BACKEND' ] && continue
                   echo "PUTVAL $host/haproxy/haproxy_backend-$pxname $time:${stot:-0}:${econ:-0}:${eresp:-0}:${hrsp_2xx:-0}:${hrsp_5xx:-0}:${dresp:-0}:${qcur:-0}:${qtime:-0}:${wredis:-0}:${wretr:-0}:${rtime:-0}:${req_rate:-0}:${req_rate_max:-0}:${req_tot:-0}:${cli_abrt:-0}:${srv_abrt:-0}:${comp_in:-0}:${comp_out:-0}:${comp_byp:-0}:${comp_rsp:-0}:${lastsess:-0}:${last_chk:-0}:${last_agt:-0}:${ctime:-0}:${ttime:-0}:${hrsp_1xx:-0}:${hrsp_3xx:-0}:${hrsp_4xx:-0}:${hrsp_other:-0}:${qmax:-0}:${scur:-0}:${smax:-0}:${slim:-0}:${bin:-0}:${bout:-0}:${dreq:-0}:${ereq:-0}:${weight:-0}:${act:-0}:${bck:-0}:${chkfail:-0}:${chkdown:-0}:${lastchg:-0}:${downtime:-0}:${qlimit:-0}:${pid:-0}:${iid:-0}:${sid:-0}:${throttle:-0}:${lbtot:-0}:${tracked:-0}:${type:-0}:${rate:-0}:${rate_lim:-0}:${rate_max:-0}:${check_status:-0}:${check_code:-0}:${check_duration:-0}:${hanafail:-0}"
               fi
        done
        sleep $pause
 done

