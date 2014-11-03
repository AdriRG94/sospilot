#! /bin/sh
# $Id: weewx.debian 2064 2014-02-05 21:13:51Z mwall $
# Author: Tom Keffer <keffer@gmail.com>
# modified by Just van den Broecke for local Raspberry Pi
# Startup script for Debian derivatives
#
# the skeleton script in debian 6 does not work properly in package scripts.
# the return/exit codes cause {pre|post}{inst|rm} to fail regardless of the
# script completion status.  this script exits explicitly.
#
# the skeleton script also does not work properly with python applications,
# as the lsb tools cannot distinguish between the python interpreter and
# the python code that was invoked.  this script uses ps and grep to look
# for the application signature instead of using the lsb tools to determine
# whether the app is running.
#
### BEGIN INIT INFO
# Provides:          weewx
# Required-Start:    $local_fs $remote_fs $syslog $time
# Required-Stop:     $local_fs $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: weewx weather system
# Description:       Manages the weewx weather system
### END INIT INFO

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
WEEWX_HOME=/opt/weewx/weewxinst
PATH=/sbin:/usr/sbin:/bin:/usr/bin
WEEWX_BIN=$WEEWX_HOME/bin/weewxd
WEEWX_CFG=$WEEWX_HOME/weewx.conf
DESC="weewx weather system"
NAME=weewx
WEEWX_USER=sadmin:sadmin
PIDFILE=$WEEWX_HOME/$NAME.pid
DAEMON=$WEEWX_BIN
DAEMON_ARGS="--daemon --pidfile=$PIDFILE $WEEWX_CFG" 
SCRIPTNAME=/etc/init.d/$NAME

# Exit if the package is not installed
[ -x "$WEEWX_BIN" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions

# start the daemon/service
#   0 if daemon has been started
#   1 if daemon was already running
#   2 if daemon could not be started
# check using ps not the pid file.  pid file could be leftover.
do_start()
{
    # normally root is owner
    # see http://askubuntu.com/questions/133235/how-do-i-allow-non-root-access-to-ttyusb0-on-12-04
    # chown $WEEWX_USER /dev/ttyUSB0
    # instead do:
    # usermod -a -G dialout $USER

    # In some cases /dev/ttyUSB1 is assigned and not /dev/ttyUSB0
    [ -c /dev/ttyUSB1 ] && [  ! -c /dev/ttyUSB0 ] && ln -s /dev/ttyUSB1 /dev/ttyUSB0; log_daemon_msg "Link /dev/ttyUSB1" || log_daemon_msg "Not present /dev/ttyUSB1"
    [ -c /dev/ttyUSB2 ] && [  ! -c /dev/ttyUSB0 ] && ln -s /dev/ttyUSB2 /dev/ttyUSB0; log_daemon_msg "Link /dev/ttyUSB2" || log_daemon_msg "Not present /dev/ttyUSB2"
    [ -c /dev/ttyUSB3 ] && [  ! -c /dev/ttyUSB0 ] && ln -s /dev/ttyUSB3 /dev/ttyUSB0; log_daemon_msg "Link /dev/ttyUSB3" || log_daemon_msg "Not present /dev/ttyUSB3"

    NPROC=`ps ax | grep $WEEWX_BIN | grep $NAME.pid | wc -l`
    if [ $NPROC != 0 ]; then
	return 1
    fi
    start-stop-daemon --start --chuid $WEEWX_USER --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_ARGS || return 2
    return 0
}

# stop the daemon/service
#   0 if daemon has been stopped
#   1 if daemon was already stopped
#   2 if daemon could not be stopped
#   other if a failure occurred
do_stop()
{
    start-stop-daemon --stop --pidfile $PIDFILE
    RETVAL="$?"
    [ "$RETVAL" = 2 ] && return 2
    # delete the pid file just in case the daemon does not
    rm -f $PIDFILE
    return "$RETVAL"
}

# send a SIGHUP to the daemon/service
do_reload() {
    start-stop-daemon --stop --signal 1 --quiet --pidfile $PIDFILE
    return 0
}

RETVAL=0
case "$1" in
    start)
	log_daemon_msg "Starting $DESC" "$NAME"
	do_start
	case "$?" in
	    0) log_end_msg 0; RETVAL=0 ;;
	    1) log_action_cont_msg " already running" && log_end_msg 0; RETVAL=0 ;;
	    2) log_end_msg 1; RETVAL=1 ;;
	esac
	;;
    stop)
	log_daemon_msg "Stopping $DESC" "$NAME"
	do_stop
	case "$?" in
	    0) log_end_msg 0; RETVAL=0 ;;
	    1) log_action_cont_msg " not running" && log_end_msg 0; RETVAL=0 ;;
	    2) log_end_msg 1; RETVAL=1 ;;
	esac
	;;
    status)
        NPROC=`ps ax | grep $WEEWX_BIN | grep $NAME.pid | wc -l`
        if [ $NPROC -gt 1 ]; then
            MSG="running multiple times"
	elif [ $NPROC = 1 ]; then
	    MSG="running"
	else
	    MSG="not running"
	fi
	log_daemon_msg "Status of $DESC:" "$MSG"
	log_end_msg 0
	RETVAL=0
	;;
    reload|force-reload)
	log_daemon_msg "Reloading $DESC" "$NAME"
	do_reload
	RETVAL=$?
	log_end_msg $RETVAL
	;;
    restart)
	log_daemon_msg "Restarting $DESC" "$NAME"
	do_stop
	case "$?" in
	    0|1)
		do_start
		case "$?" in
		    0) log_end_msg 0; RETVAL=0 ;;
		    1) log_end_msg 1; RETVAL=1 ;; # Old process is still running
		    *) log_end_msg 1; RETVAL=1 ;; # Failed to start
		esac
		;;
	    *)
	  	# Failed to stop
		log_end_msg 1
		RETVAL=1
		;;
	esac
	;;
    *)
	echo "Usage: $SCRIPTNAME {start|stop|status|restart|reload}"
	exit 3
	;;
esac

exit $RETVAL

