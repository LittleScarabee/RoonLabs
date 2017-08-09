#!/bin/sh

echo "

# ---------------------------------------------
#
# Name	  : Roon Labs RT Audiophile Orientation / Auto-Install
#
# Author  : LittleScarabee
# Version : 1.2 / 08-AUG-2017
#
# Step 3 - Description :
#  1 / Install RoonServer (Server & Dependancies & Extensions Manager)
#  2 / Install RoonBridge 
#  3 / Reboot
#
# ---------------------------------------------

"

# Log File
FILE_LOG=log-RoonLabs_RT_Audiophile_Orientation-Step-03.log
if [ ! -f $FILE_LOG ]; then
	touch $FILE_LOG
	sleep 2
fi


echo "
# ----------------------------------------------- #
# 1/3 | Install RoonServer						  #
# ----------------------------------------------- #"
# Get last step executed
STEP_ID=1
STEP_LAST=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $3; }')
STEP_STATUS=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $4; }')
#echo $(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1)

# If never run
if [ "$STEP_LAST" = "" ]
then
        STEP_LAST=STEP_$STEP_ID
        STEP_STATUS="0"
fi

# Start
if [ "$STEP_LAST" = "STEP_$STEP_ID" ] && [ "$STEP_STATUS" = "0" ]
then
        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=0
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG

        # Script
        echo -e ">>> Do you want to install RoonServer (Y/N) ?"
        read REP_USER
        if [ "$REP_USER" = "O" ] || [ "$REP_USER" = "o" ] || [ "$REP_USER" = "y" ] || [ "$REP_USER" = "Y" ]
		then
			
			echo ""
			echo ">>> Install Dependancies for RoonServer..."
			sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
			sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
			sudo dnf update
			sudo dnf install -y ffmpeg alsa-utils cifs-utils glibc
	
			echo ""
			echo ">>> Install Dependancies for RoonServer Extensions..."
			sudo dnf install -y gcc-c++ make git curl
			echo "Authentification requise en tant que 'ROOT', merci de saisir votre"
			su -c "curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -"
			sudo dnf install -y nodejs
			
			echo ""
			echo ">>> Install Roon Server..."
			sudo curl -O http://download.roonlabs.com/builds/roonserver-installer-linuxx64.sh
			sudo chmod +x roonserver-installer-linuxx64.sh
			sudo printf "y\ny\n" | ./roonserver-installer-linuxx64.sh && tail -f /dev/null 
			sudo rm -f roonserver-installer-linuxx64.sh
			
			echo ""
			echo ">>> Install Roon Extensions Manager..."
			echo ""
			mkdir ~/RoonExtensions
			npm config set prefix '~/RoonExtensions'
			npm install -g https://github.com/TheAppgineer/roon-extension-manager.git
			cd ~/RoonExtensions/lib/node_modules/roon-extension-manager
			node start.js
			
        else
        	
        	echo ""
        	echo " >> Installation cancelled..."
        	
        fi
        
        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=1
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG

else
        echo ">>> Step already done..."
fi

echo "
# ----------------------------------------------- #
# 2/3 | Install RoonBridge						  #
# ----------------------------------------------- #"
# Get last step executed
STEP_ID=2
STEP_LAST=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $3; }')
STEP_STATUS=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $4; }')
#echo $(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1)

# If never run
if [ "$STEP_LAST" = "" ]
then
        STEP_LAST=STEP_$STEP_ID
        STEP_STATUS="0"
fi

# Start
if [ "$STEP_LAST" = "STEP_$STEP_ID" ] && [ "$STEP_STATUS" = "0" ]
then
        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=0
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG

        # Script
        echo -e ">>> Do you want to install RoonBridge (Y/N) ?"
        read REP_USER
        if [ "$REP_USER" = "O" ] || [ "$REP_USER" = "o" ] || [ "$REP_USER" = "y" ] || [ "$REP_USER" = "Y" ]
		then
		
			echo ""
			echo ">>> Install Roon Bridge.."
			echo ""
			sudo curl -O http://download.roonlabs.com/builds/roonbridge-installer-linuxx64.sh
			sudo chmod +x roonbridge-installer-linuxx64.sh
			sudo printf "y\ny\n" | ./roonbridge-installer-linuxx64.sh && tail -f /dev/null
			
        else
        	
        	echo ""
        	echo " >> Installation cancelled..."
        	
        fi
        
        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=1
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG

else
        echo ">>> Step already done..."
fi


echo "
# ----------------------------------------------- #
# 3/3 | Reboot									  #
# ----------------------------------------------- #"
STEP_ID=3
STEP_LAST=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $3; }')
STEP_STATUS=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $4; }')
#echo $(sudo cat $FILE_LOG | grep STEP_$STEP_ID | tail -1)

# If never run
if [ "$STEP_LAST" = "" ]
then
        STEP_LAST=STEP_$STEP_ID
        STEP_STATUS=0
fi

# Start 
if [ "$STEP_LAST" = "STEP_$STEP_ID" ] && [ "$STEP_STATUS" = "0" ]
then
	# Reboot needed
	echo -e ">>> Reboot of the server is needed, do you want to do it now (Y/N) ?"
	read REP_USER
	if [ "$REP_USER" = "O" ] || [ "$REP_USER" = "o" ] || [ "$REP_USER" = "y" ] || [ "$REP_USER" = "Y" ]
	then
		# LOG
        	NOW=$(date +"%Y-%m-%d %T")
        	STEP_STATUS=1
        	#echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
		echo ">>> The server will reboot in 10 seconds..."
        	sleep 10
        	sudo reboot
	else
		# LOG
        	NOW=$(date +"%Y-%m-%d %T")
        	STEP_STATUS=0
        	echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
		echo ">>> Reboot cancelled..."
	fi
else
	echo ">>> Reboot already done..."
fi
