#!/bin/sh

echo "

# ---------------------------------------------
#
# Name	  : Roon Labs RT Audiophile Orientation / Auto-Install
#
# Author  : LittleScarabee
# Version : 1.1 / 2017-07-23 / Solve issue on the kernel name we have to install
# Version : 1.0 / 2017-07-23 / Creation
#
# Step 2 - Description :
#  1 / Install kernel MAO CCRMA
#  2 / Enable kernel MAO CCRMA
#  3 / Reboot
#
# ---------------------------------------------

"

# Log File
FILE_LOG=log-RoonLabs_RT_Audiophile_Orientation-Step-02.log
if [ ! -f $FILE_LOG ]; then
	touch $FILE_LOG
	sleep 2
fi


echo "

# ------------------------------- #
# 1/3 | Install Kernel RT CCRMA   #
# ------------------------------- #"
# Get last step executed
STEP_ID=1
STEP_LAST=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $3; }')
STEP_STATUS=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $4; }')
#echo $(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1)

# If never run
if [ "$STEP_LAST" = "" ]; then
	STEP_LAST=STEP_$STEP_ID
	STEP_STATUS="0"
fi

# Start
if [ "$STEP_LAST" = "STEP_$STEP_ID" ] && [ "$STEP_STATUS" = "0" ]; then
        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=0
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
	
	STR_OUTPUT=$(uname -r | awk -F'.' '{ print $5; }')
        # Script
	echo ">>> Type de système detecté : $STR_OUTPUT"
	echo ""
	echo ">>> Authentification requise en tant que 'ROOT', merci de saisir votre"
	su -c 'rpm -Uvh http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetccrma/$(rpm -E %fedora)/x86_64/planetccrma-repo-1.1-3.fc$(rpm -E %fedora).ccrma.noarch.rpm'
	#sudo dnf info planetccrma-core
	#sudo dnf install -y planetccrma-core
	
	sudo dnf info kernel-rt
	sudo dnf install -y kernel-rt
        
	# LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=1
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
else
        echo ">>> Etape déjà exécutée..."
fi

echo "

# ------------------------------- #
# 2/3 | Enable Kernel CCRMA       #
# ------------------------------- #"
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
	echo ""
	echo ">>> Votre noyau actuel est le suivant :"
	uname -a                       
	echo ""
	sudo grub2-mkconfig -o /boot/grub2/grub.cfg
	echo "" 
	echo ">>> Le noyau CCRMA est détecté dans la version suivante :"
	STR_OUTPUT=$(sudo grep ^menuentry /boot/grub2/grub.cfg | cut -d "'" -f2 | grep ccrma)
	echo $STR_OUTPUT
	echo ""	
	echo -e ">>> Souhaitez-vous qu'il soit le noyau par défaut maintenant (Y/N) ?"
        read REP_USER
        if [ "$REP_USER" = "O" ] || [ "$REP_USER" = "o" ] || [ "$REP_USER" = "y" ] || [ "$REP_USER" = "Y" ]
        then
		sudo grub2-set-default "$(sudo grep ^menuentry /boot/grub2/grub.cfg | cut -d "'" -f2 | grep ccrma)"
		sudo grub2-editenv list
                echo ">>> Modification effectuée dans GRUB...."

        	# LOG
        	NOW=$(date +"%Y-%m-%d %T")
        	STEP_STATUS=1
        	echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
	else
		echo ">>> Aucune modification apportée dans GRUB...."
	fi
else
        echo ">>> Etape déjà exécutée..."
fi


echo "

# ------------------------------- #
# 3/3 |  Step 2 Completed	  #
# ------------------------------- #"
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
	echo -e ">>> Le redemarrage du serveur est nécessaire, souhaitez-vous redémarrer maintenant (Y/N) ?"
	read REP_USER
	if [ "$REP_USER" = "O" ] || [ "$REP_USER" = "o" ] || [ "$REP_USER" = "y" ] || [ "$REP_USER" = "Y" ]
	then
		# LOG
        	NOW=$(date +"%Y-%m-%d %T")
        	STEP_STATUS=1
        	#echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
		echo ">>> Le serveur va redémarré dans 10 secondes..."
        	sleep 10
        	sudo reboot
	else
		# LOG
        	NOW=$(date +"%Y-%m-%d %T")
        	STEP_STATUS=0
        	echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
		echo ">>> Redémarrage annulé..."
	fi
else
	echo ">>> Redémarrage déjà effectué..."
fi
