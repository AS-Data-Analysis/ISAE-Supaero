#!/bin/bash
PROBCOMMAND=probcli
# use following line if you wish ProB2 to use probproxy and start probcli -s 8888 from source separately:
# PROBCOMMAND=probproxy
INTERRUPT_COMMAND=send_user_interrupt

# Shell wrapper for PROBCOMMAND

echo "Running ProB Command-line Interface"
echo "$PROBCOMMAND" "$@"

# dirname
dirname=`dirname "$0"`

ulimit -d unlimited

chmod a+x "$dirname/$PROBCOMMAND"
chmod a+x "$dirname/$INTERRUPT_COMMAND"
LD_LIBRARY_PATH="lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" SP_TIMEOUT_IMPLEMENTATON="legacy" exec  "$dirname/$PROBCOMMAND" "$@"
