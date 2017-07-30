#!/bin/sh

echo "

# ---------------------------------------------
# 
# Name:  Roon Labs RT Audiophile Orientation / Auto-Install
# 
# Author  : LittleScarabee
# Version : 1.0 / 2017-07-23
#
# Step 1 - Description :
#  1 / Give grant access to user (ie: $(whoami))
#  2 / Add more repositories
#  3 / Install Network Tools
#  4 / Disabled Firewall
#  5 / Desabled  SELinux
#  6 / Reboot
#
# ---------------------------------------------

"

# Log File
FILE_LOG=log-RoonLabs_RT_Audiophile_Orientation-Step-01.log
if [ ! -f $FILE_LOG ]; then
	touch $FILE_LOG
	sleep 2
fi



echo "

# ---------------------------------- #
# 1/6 | Grant Access to current user #
# ---------------------------------- #"
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
	
	# Script
	STR_GRP=$(cat /etc/group | grep $(whoami) | grep wheel | awk -F':' '{ print $1; }')
	# Check group
	if [ "$STR_GRP" != "wheel" ]; then
		# Script

    	echo ""
		read -p ">>> Les privilièges vont être accordés au compte '$(whoami)', êtes-vous d'accord ? (sinon saisir le compte utilisateur) " rep_user
		REP_USER=${rep_user:-$(whoami)}
		echo $REP_USER
		
	else
		echo "User '$(whoami)' is already in the group 'wheel'..."
	fi 
	
	echo "Authentification requise en tant que 'ROOT', merci de saisir votre"
	$(su -c "usermod -aG wheel $(whoami) ; echo '%wheel ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers")
		
	# Script
	STR_GRP=$(cat /etc/group | grep $(whoami) | grep wheel | awk -F':' '{ print $1; }')
	# Check group
    if [ "$STR_GRP" != "wheel" ]; then
		echo "!!! Erreur !!! Impossible d'ajouter l'utilisateur '$(whoami)' au groupe 'wheel'"
		echo "Exécuter manuellement les commandes suivantes : "
		echo "su -c \"usermod -aG wheel $(whoami)\""
        echo "su -c \"echo '%wheel     ALL=(ALL)       NOPASSWD: ALL' | (EDITOR='tee -a' visudo)\""
		NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=1
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
		exit
	else
		# LOG
        NOW=$(date +"%Y-%m-%d %T")
   		STEP_STATUS=1
		echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
		echo "Privilège accordé avec succès ! Votre session va être fermée pour prendre en compte les changements."
		sleep 3
		pkill -9 -u $(whoami)
		exit
	fi

else
	echo "Etape déjà exécutée..."
fi

echo "

# ------------------------------- #
# 2/6 | Add repositories & Update #
# ------------------------------- #"
# Get last step executed
STEP_ID=2
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

        # Script
		sudo dnf update -y
		sudo dnf upgrade -y
		sudo dnf install -y yum-plugin-fastestmirror deltarpm yum-plugin-priorities vim

        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=1
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
else
        echo "Etape déjà exécutée..."
fi

echo "

# ------------------------------- #
# 3/6 | Install Network Tools     #
# ------------------------------- #"
# Get last step executed
STEP_ID=3
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
        dnf provides ifconfig
		sudo dnf install -y net-tools system-config-network

        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=1
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
else
        echo "Etape déjà exécutée..."
fi


echo "

# ------------------------------- #
# 4/6 |  Disabled Firewall    	  #
# ------------------------------- #"
# Get last step executed
STEP_ID=4
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
	sudo systemctl disable firewalld	
        sudo systemctl stop firewalld
	sudo dnf remove firewalld -y
	echo "Ci-dessous le statut de votre firewall :"
	STR_OUTPUT=$(systemctl status firewalld | grep "Active:")
	echo $STR_OUTPUT

        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=1
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
else
        echo "Etape déjà exécutée..."
fi


echo "

# ------------------------------- #
# 5/6 |  Disabled SE Linux        #
# ------------------------------- #"
# Get last step executed
STEP_ID=5
STEP_LAST=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $3; }')
STEP_STATUS=$(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1 | awk '{ print $4; }')
#echo $(cat $FILE_LOG | grep STEP_$STEP_ID | tail -1)

# If never run
if [ "$STEP_LAST" = "" ]
then
        STEP_LAST=STEP_$STEP_ID
        STEP_STATUS=0
fi

# Start
if [ "$STEP_LAST" = "STEP_$STEP_ID" ] && [ "$STEP_STATUS" = "0" ]
then 
        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=0                   
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG

        # Script
	echo "Le chargement 'SELinux policy' est maintenant "
	$(sudo sed --in-place=.bak 's/^SELINUX\=enforcing/SELINUX\=disabled/g' /etc/selinux/config)
	STR_OUTPUT=$(sudo cat /etc/selinux/config | egrep "SELINUX=" | tail -1)
	echo $STR_OUTPUT

        # LOG
        NOW=$(date +"%Y-%m-%d %T")
        STEP_STATUS=1
        echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
else
        echo "Step already done..."
fi


echo "

# ------------------------------- #
# 6/6 |  Step 1 Completed	  #
# ------------------------------- #"
STEP_ID=6
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
	echo -e "Le redemarrage du serveur est nécessaire, souhaitez-vous redémarrer maintenant (Y/N) ?"
	read REP_USER
	if [ "$REP_USER" = "O" ] || [ "$REP_USER" = "o" ] || [ "$REP_USER" = "y" ] || [ "$REP_USER" = "Y" ]
        then
		# LOG
        	NOW=$(date +"%Y-%m-%d %T")
        	STEP_STATUS=1
        	echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
		echo "Le serveur va redémarré dans 10 secondes..."
        	sleep 10
        	sudo reboot
	else
		# LOG
        	NOW=$(date +"%Y-%m-%d %T")
        	STEP_STATUS=0
        	echo "$NOW      STEP_$STEP_ID        $STEP_STATUS">>$FILE_LOG
		echo "Redémarrage annulé..."
	fi
else
	echo "Redémarrage déjà effectué..."
fi


