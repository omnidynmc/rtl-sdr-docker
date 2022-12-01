#!/bin/sh

handle_signal (){
	PID=$!
	echo "received signal. PID is ${PID}"
	kill -s SIGHUP $PID
}

trap "handle_signal" SIGINT SIGTERM SIGHUP

if [[ "$1" == "rtl-tcp" ]] ; then
	chgrp -R 1000 /dev/bus/usb
	exec su user -c "rtl_tcp -a 0.0.0.0 -p $PORT $RTLTCP_ARGS"
else
	exec "$@"
fi

