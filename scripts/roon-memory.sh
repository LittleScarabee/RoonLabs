#!/bin/bash
while true; do
        echo -e "Que souhaitez-vous faire : Controler la mémoire (check) ou Vider le cache (clear) ?"
        read rep_user
        case $rep_user in
                check )
                        echo -e "\n######### Utilisation du serveur #########"
                        free -h;
                        echo -e "\n######### RoonServer #########"
                        ps aux | grep RoonServer | grep -v grep | awk 'BEGIN { sum=0 } {sum=sum+$6; } END {printf("Utilisation = %s Mo\n",sum / 1024)}';
                        echo -e "\n######### RoonAppliance #########"
                        ps aux | grep RoonAppliance | grep -v grep | awk 'BEGIN { sum=0 } {sum=sum+$6; } END {printf("Utilisation = %s Mo\n",sum / 1024)}';
                        echo -e "\n######### RAATServer #########"
                        ps aux | grep RAATServer | grep -v grep | awk 'BEGIN { sum=0 } {sum=sum+$6; } END {printf("Utilisation = %s Mo\n",sum / 1024)}';
                        echo -e "\n######### RoonBridge #########"
                        ps aux | grep RoonBridge | grep -v grep | awk 'BEGIN { sum=0 } {sum=sum+$6; } END {printf("Utilisation = %s Mo\n",sum / 1024)}';
                        echo -e "\n######### RoonHelper #########"
                        ps aux | grep RoonHelper | grep -v grep | awk 'BEGIN { sum=0 } {sum=sum+$6; } END {printf("Utilisation = %s Mo\n",sum / 1024)}';
                        break;;

                clear )
                        echo -e "\n######### Utilisation mémoire avant #########"
                        free -h;
                        echo -e "\n>>> Authentification requise en tant que 'ROOT', merci de saisir votre"
                        $(su -c "sync; echo 3 > /proc/sys/vm/drop_caches");
                        echo -e "\n######### Utilisation mémoire après #########"
                        free -h
                        break;;

                * )
                        echo -e "\n>>>> Merci de choisir une des deux options suivantes : check ou clear.\n";;
        esac
done
