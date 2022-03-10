#!/bin/sh

# LINUX OS SETUP SCRIPT V1.4
#
# Firewall setup
# Full OS upgrade
# Sublime Text 3
# speedtest-cli
# gnome-chess
# youtube-dl
# Environment config



# check status
status()
{
	case "$1" in
		"install")
			if [ "$2" = true ]; then
				echo "\n${3} successful\n"
			else
				echo "\n${3} failed\n"
			fi;
			;;

		"check")
			if [ "$2" = true ]; then
				echo "${3}: OK"
			else
				echo "${3}: failed"
			fi;
			;;
	esac
}


# check OS
OS=$(cat /etc/issue | awk '{print $1, $2}' | sed -e 's/^[ \t]*//')

# check chassis
CHASSIS=$(hostnamectl status | grep Chassis | cut -f2 -d ":" | tr -d ' ')



# elevation
echo "\nLinux OS setup script V1.4\n"
sudo whoami

# status variables
UFWSETUP=false
FULLUPGRADE=false
SUBLIMETEXT=false
SPEEDTESTCLI=false
GNOMECHESS=false
YOUTUBEDL=false
ENVIRONMENTCONFIG=false



# firewall setup
echo "\nFirewall setup...\n"
sudo ufw enable &&
sudo ufw default deny incoming &&
sudo ufw default allow outgoing &&
sudo ufw reload &&
sudo ufw status verbose &&
UFWSETUP=true || UFWSETUP=false

# firewall status
status "install" $UFWSETUP "Firewall setup"



# full upgrade & clean up
echo "\nFull upgrade & clean up...\n"
sudo apt update &&
sudo apt full-upgrade -y &&
sudo apt autoclean &&
sudo apt autoremove -y &&
FULLUPGRADE=true || FULLUPGRADE=false

# full upgrade status
status "install" $FULLUPGRADE "Full-upgrade"



# install and setup Sublime Text 3
echo "\nInstalling Sublime Text 3...\n"

## install GPG key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &&

## set up apt to work with https sources
sudo apt install apt-transport-https &&

## use stable upgrade repository
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list &&

## update apt and install Sublime Text 3
sudo apt update &&
sudo apt install sublime-text &&
SUBLIMETEXT=true || SUBLIMETEXT=false

# sublime text 3 status
status "install" $SUBLIMETEXT "Sublime Text 3"



# install speedtest-cli
echo "\nInstalling speedtest-cli...\n"
sudo apt install python3-pip -y &&
sudo pip3 install speedtest-cli &&
echo "\nRunning speedtest...\n" &&
speedtest &&
echo "\ndone" &&
SPEEDTESTCLI=true || SPEEDTESTCLI=false

# speedtest-cli status
status "install" $SPEEDTESTCLI "speedtest-cli"



# install gnome-chess
echo "\nInstalling gnome-chess...\n"
sudo apt install gnome-chess -y &&
GNOMECHESS=true || GNOMECHESS=false

# gnome-chess status
status "install" $GNOMECHESS "gnome-chess"



# install youtube-dl
echo "\nInstalling youtube-dl...\n"
sudo pip3 install youtube-dl &&
sudo apt install ffmpeg &&
YOUTUBEDL=true || YOUTUBEDL=false

# youtube-dl status
status "install" $YOUTUBEDL "youtube-dl"



# environment setup
echo "\nEnvironment config for OS: ${OS}..."

case "$OS" in
	"Peppermint Ten")
		echo "Xfce4 panel configuration..."

		## remove videos
		xfconf-query -c xfce4-panel -p /plugins/plugin-5 -rR &&

		## remove pager
		xfconf-query -c xfwm4 -p /general/workspace_count -s 1 &&
		xfconf-query -c xfce4-panel -p /plugins/plugin-8 -rR &&

		## remove power manager icon, if not laptop
		if ! [ "$CHASSIS" = "laptop" ]; then
			xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 0
		fi;

		## keyboard layout config
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-type" -t uint -s "2" &&
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-name" -t uint -s "1" &&
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-tooltip-icon" -t bool -s "false" &&
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/group-policy" -t uint -s "0" &&

		## clock config & timezone
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-12/digital-format" -t string -s "%H:%M %a %d/%m/%Y" &&
		sudo timedatectl set-timezone Europe/Copenhagen &&

		## restart xfce4 panel
		echo "Restarting XFCE4 panel..." &&
		xfce4-panel -r
		;;

	"Linux Mint")
		echo "Cinnamon panel configuration..."
		
		## set timezone
		sudo timedatectl set-timezone Europe/Copenhagen &&
		
		## config panels
		dconf write /org/cinnamon/panels-enabled "['1:0:bottom', '2:1:bottom', '3:2:bottom']" &&
		dconf write /org/cinnamon/panels-height "['1:24', '2:24', '3:24']" &&
		dconf write /org/cinnamon/panel-zone-icon-sizes '[{"left":0,"center":0,"right":0,"panelId":1}, {"left":0,"center":0,"right":0,"panelId":2}, {"left":0,"center":0,"right":0,"panelId":3}]' &&
		
		## set panel icons
		if ! [ "$CHASSIS" = "laptop" ]; then
			dconf write /org/cinnamon/enabled-applets "['panel1:left:0:menu@cinnamon.org','panel1:left:1:panel-launchers@cinnamon.org','panel1:left:2:window-list@cinnamon.org','panel1:right:0:systray@cinnamon.org','panel1:right:1:xapp-status@cinnamon.org','panel1:right:2:keyboard@cinnamon.org','panel1:right:3:notifications@cinnamon.org','panel1:right:4:printers@cinnamon.org','panel1:right:5:removable-drives@cinnamon.org','panel1:right:6:network@cinnamon.org','panel1:right:7:sound@cinnamon.org','panel1:right:8:calendar@cinnamon.org','panel2:left:0:menu@cinnamon.org','panel2:left:1:panel-launchers@cinnamon.org','panel2:left:2:window-list@cinnamon.org','panel2:right:0:systray@cinnamon.org','panel2:right:1:xapp-status@cinnamon.org','panel2:right:2:keyboard@cinnamon.org','panel2:right:3:notifications@cinnamon.org','panel2:right:4:printers@cinnamon.org','panel2:right:5:removable-drives@cinnamon.org','panel2:right:6:network@cinnamon.org','panel2:right:7:sound@cinnamon.org','panel2:right:8:calendar@cinnamon.org', 'panel3:left:0:menu@cinnamon.org','panel3:left:1:panel-launchers@cinnamon.org','panel3:left:2:window-list@cinnamon.org','panel3:right:0:systray@cinnamon.org','panel3:right:1:xapp-status@cinnamon.org','panel3:right:2:keyboard@cinnamon.org','panel3:right:3:notifications@cinnamon.org','panel3:right:4:printers@cinnamon.org','panel3:right:5:removable-drives@cinnamon.org','panel3:right:6:network@cinnamon.org','panel3:right:7:sound@cinnamon.org','panel3:right:8:calendar@cinnamon.org']"
		else
			dconf write /org/cinnamon/enabled-applets "['panel1:left:0:menu@cinnamon.org','panel1:left:1:panel-launchers@cinnamon.org','panel1:left:2:window-list@cinnamon.org','panel1:right:0:systray@cinnamon.org','panel1:right:1:xapp-status@cinnamon.org','panel1:right:2:keyboard@cinnamon.org','panel1:right:3:notifications@cinnamon.org','panel1:right:4:printers@cinnamon.org','panel1:right:5:removable-drives@cinnamon.org','panel1:right:6:network@cinnamon.org','panel1:right:7:sound@cinnamon.org','panel1:right:8:power@cinnamon.org','panel1:right:9:calendar@cinnamon.org','panel2:left:0:menu@cinnamon.org','panel2:left:1:panel-launchers@cinnamon.org','panel2:left:2:window-list@cinnamon.org','panel2:right:0:systray@cinnamon.org','panel2:right:1:xapp-status@cinnamon.org','panel2:right:2:keyboard@cinnamon.org','panel2:right:3:notifications@cinnamon.org','panel2:right:4:printers@cinnamon.org','panel2:right:5:removable-drives@cinnamon.org','panel2:right:6:network@cinnamon.org','panel2:right:7:sound@cinnamon.org','panel2:right:8:power@cinnamon.org','panel2:right:9:calendar@cinnamon.org', 'panel3:left:0:menu@cinnamon.org','panel3:left:1:panel-launchers@cinnamon.org','panel3:left:2:window-list@cinnamon.org','panel3:right:0:systray@cinnamon.org','panel3:right:1:xapp-status@cinnamon.org','panel3:right:2:keyboard@cinnamon.org','panel3:right:3:notifications@cinnamon.org','panel3:right:4:printers@cinnamon.org','panel3:right:5:removable-drives@cinnamon.org','panel3:right:6:network@cinnamon.org','panel3:right:7:sound@cinnamon.org','panel3:right:8:power@cinnamon.org','panel3:right:9:calendar@cinnamon.org']"
		fi;

		cinnamon --replace > /dev/null 2>&1 & disown
		;;
esac

# environment config status
status "install" $ENVIRONMENTCONFIG "Environment setup"



# print status
echo "\n\nStatus:\n"
status "check" $UFWSETUP "Firewall setup"
status "check" $FULLUPGRADE "Full-upgrade"
status "check" $SUBLIMETEXT "Sublime Text 3"
status "check" $SPEEDTESTCLI "speedtest-cli"
status "check" $GNOMECHESS "gnome-chess"
status "check" $YOUTUBEDL "youtube-dl"
status "check" $ENVIRONMENTCONFIG "Environment setup"



# end message
echo "\nSetup completed\n"
