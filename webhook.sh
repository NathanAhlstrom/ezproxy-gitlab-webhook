#!/bin/sh
#
# Note runlevel 2345, 86 is the Start order and 85 is the Stop order
#
# chkconfig: 2345 86 85
# description: Description of the Service
#
# instructions: copy this file to /etc/init.d/webhook
# run chkconfig --add webhook
# from: http://blog.aronduby.com/starting-node-forever-scripts-at-boot-w-centos/
#
# Below is the source function library, leave it be
. /etc/init.d/functions

# result of whereis forever or whereis node
# forever node startup script is in /usr/bin/forever
export PATH=$PATH:/usr/bin  

# result of whereis node_modules
export NODE_PATH=$NODE_PATH:/usr/lib/node_modules

FOREVER="/usr/bin/forever";
NODEPROG="/opt/ezproxy-webhook/WebhookServer.js"
NODELOGS="/opt/ezproxy-webhook/logs"
NODEARGS="-s -a -l $NODELOGS/forever.log -o $NODELOGS/webhookOutput.log -e $NODELOGS/webhookError.log";


start(){  
	$FOREVER start $NODEARGS $NODEPROG >/dev/null 2>&1
}

stop(){  
	$FOREVER stop $NODEARGS $NODEPROG >/dev/null 2>&1
}

restart(){  
	$FOREVER restart $NODEARGS $NODEPROG >/dev/null 2>&1
}

case "$1" in  
	start)
		echo "Start service Proxy Webhook Server"
		start
		;;
	stop)
		echo "Stop service Proxy Webhook Server"
		stop
		;;
	restart)
		echo "Restart service Proxy Webhook Server"
		restart
		;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
		;;
esac

