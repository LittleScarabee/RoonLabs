#!/bin/bash

# ProcessusName
PROC_ROON="RoonServer"
PROC_BRIDGE="RoonBridge"
PROC_RAAT="RAATServer"
PROC_APPLIANCE="RoonAppliance"

# Options
STR_HELP="
How to use this script : 
 roon-realtime.sh PARAMETERS OPTIONS

Example for Server: roon-realtime.sh -p 99 -m FIFO -s y -a y -r y 
Example for Brige: roon-realtime.sh -p 99 -m FIFO -b y -a y -r y 

 * Options (At least one of them)
 s = Server
 a = Appliance
 r = RAAT
 b = Bridge

 * Parameters
 m = Scheduling >> {FIFO|RR}
 p = Priority   >> {0-99}
"
while getopts s:a:r:b:m:p:h: option
do
 case "${option}"
   in
        s)
                OPT_ROON=${OPTARG}
                echo "## Option $PROC_ROON selected..."
                ;;
        a)
                OPT_APPLIANCE=${OPTARG}
                echo "## Option $PROC_APPLIANCE selected..."
                ;;
        r)
                OPT_RAAT=${OPTARG}
                echo "## Option $PROC_RAAT selected..."
                ;;
        b)
                OPT_BRIDGE=${OPTARG}
                echo "## Option $PROC_BRIDGE selected..."
                ;;
        m)
                SCHED_CMD=${OPTARG}
                echo "## Scheduling $SCHED_CMD  selected..."
                ;;
        p)
                SCHED_RANGE=${OPTARG}
                echo "## Priority $SCHED_RANGE selected..."
                ;;
        h)
                echo $STR_HELP
                exit 0
                ;;
 esac
done

# Check if the service are running
FLAG=0
echo "- - - -"
while [ $FLAG -le 3 ] ; do
        # Check if the process is started
        if [ -f /proc/$(pidof $PROC_ROON)/exe ]; then
                FLAG=$(($FLAG + 1))
                echo "## Service $PROC_ROON started..."
        else
                echo "## Service $PROC_ROON not started..."
        fi
        # Check if the process is started
        if [ -f /proc/$(pidof $PROC_APPLIANCE)/exe ]; then
                FLAG=$(($FLAG + 1))
                echo "## Service $PROC_APPLIANCE started..."
        else
                echo "## Service $PROC_APPLIANCE not started..."
        fi
        # Check if the process is started
        if [ -f /proc/$(pidof $PROC_RAAT)/exe ]; then
                FLAG=$(($FLAG + 1))
                echo "## Service $PROC_RAAT started"
        else
                echo "## Service $PROC_RAAT not started"
        fi
        # Check if the process is started
        if [ -f /proc/$(pidof $PROC_BRIDGE)/exe ]; then
                FLAG=$(($FLAG + 1))
                echo "## Service $PROC_BRIDGE started..."
        else
                echo "## Service $PROC_BRIDGE not started..."
        fi
        # Pause
        sleep 3
done
# Pause
echo "## Pause 5 secs..."
sleep 5
echo "- - - -"


# Schedule Round robin
if [ "$SCHED_CMD" == "RR" ] || [ "$SCHED_CMD" == "rr" ]; then
        SCHED_CMD="-r"
fi

# Schedule First in, first out
if [ "$SCHED_CMD" == "FIFO" ] || [ "$SCHED_CMD" == "fifo" ]; then
        SCHED_CMD="-f"
fi

# Iteration for RoonServer 
if [ "$OPT_ROON" == "Y" ] || [ "$OPT_ROON" == "y" ]; then
        ARR_PID=$(sudo ls /proc/$(pidof $PROC_ROON)/task/)
        INT_ROWS=0
        for p_id in $ARR_PID;
                do
                        echo "## Process: $(pstree $p_id) "
                        chrt $SCHED_CMD -p $SCHED_RANGE $p_id
                        chrt -p $p_id
                        INT_ROWS=$(($INT_ROWS + 1));
                done
        echo "## -----------------------------------------------------------------"
        echo "## Parent Process [$PROC_ROON] >> $INT_ROWS child process updated..."
        echo "## -----------------------------------------------------------------"
fi

# Iteration for RoonBridge
if [ "$OPT_BRIDGE" == "Y" ] || [ "$OPT_BRIDGE" == "y" ]; then
        ARR_PID=$(sudo ls /proc/$(pidof $PROC_BRIDGE)/task/)
        INT_ROWS=0
        for p_id in $ARR_PID;
                do
                        echo "## Process: $(pstree $p_id) "
                        chrt $SCHED_CMD -p $SCHED_RANGE $p_id
                        chrt -p $p_id
                        INT_ROWS=$(($INT_ROWS + 1));
                done
        echo "## -----------------------------------------------------------------"
        echo "## Parent Process : [$PROC_BRIDGE] >> $INT_ROWS child process updated..."
        echo "## -----------------------------------------------------------------"
fi

# Iteration for RAATServer
if [ "$OPT_RAAT" == "Y" ] || [ "$OPT_RAAT" == "y" ]; then
        ARR_PID=$(sudo ls /proc/$(pidof $PROC_RAAT)/task/)
        INT_ROWS=0
        for p_id in $ARR_PID;
                do
                        echo "## Process: $(pstree $p_id) "
                        chrt $SCHED_CMD -p $SCHED_RANGE $p_id
                        chrt -p $p_id
                        INT_ROWS=$(($INT_ROWS + 1));
                done
        echo "## -----------------------------------------------------------------"
        echo "## Parent Process : [$PROC_RAAT] >> $INT_ROWS child process updated..."
        echo "## -----------------------------------------------------------------"
fi

# Iteration for RoonAppliance
if [ "$OPT_APPLIANCE" == "Y" ] || [ "$OPT_APPLIANCE" == "y" ]; then
        ARR_PID=$(sudo ls /proc/$(pidof $PROC_APPLIANCE)/task/)
        INT_ROWS=0
        for p_id in $ARR_PID;
                do
                        echo "## Process: $(pstree $p_id) "
                        chrt $SCHED_CMD -p $SCHED_RANGE $p_id
                        chrt -p $p_id
                        INT_ROWS=$(($INT_ROWS + 1));
                done
        echo "## -----------------------------------------------------------------"
        echo "## Parent Process : [$PROC_APPLIANCE] >> $INT_ROWS child process updated..."
        echo "## -----------------------------------------------------------------"
fi
