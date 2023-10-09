#!/bin/zsh

##############################################################################################
# Script to install apps and runs scripts for deploying to a user.
# Enter your own icon/title/etc in the variables below
# Setup to use Jamf triggers to install apps and run scripts
# If using with less than 15 apps/scripts, need to delete from:
#
# App Common Name
# Path to check if app is already installed
# Jamf Custom Trigger
# Icon Path
# Installing Text
# Success Text
# Installing Apps
#
# To verify scripts have run, I put this command at the end of the script if successful, then use it to verify within this script.
# touch "/Library/Application Support/JAMF/Receipts/package.pkg"
#
# Swiftdialog parts based on https://gist.github.com/smithjw/b61a180b099624cebf61a8460fc594ed
# Original script "flow" by @nstrauss
##############################################################################################

#############
# Variables #
#############

LOGGED_IN_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
LOG_FOLDER="/private/var/log"
LOG_NAME="enrollment.log"
JAMF_BINARY="/usr/local/bin/jamf"
DIALOG_APP="/usr/local/bin/dialog"
DIALOG_COMMAND_FILE="/var/tmp/dialog.log"
DIALOG_ICON="/path/to/icon"
DIALOG_INITIAL_TITLE="Welcome to Organization!"
DIALOG_INITIAL_MESSAGE="Please wait a few minutes while we set up your Mac.  \n  \nTo use organization provided technology you are required to adhere to the organization acceptable use policy. Full text of the policy can be found online at https://www.google.com"
SUCCESSTITLE="Success!"
SUCCESSICON="sf=checkmark.circle.fill color1=green weight=bold"
SUCCESSDESC="Success! This window will close in 10 seconds"
FAILTITLE="Process Failed"
FAILICON="sf=xmark.octagon color=red weight=bold"

#################################################################
# Determine if the network is up by looking for any non-loopback 
# or self-assigned internet network interfaces
#################################################################

NETWORKSTATUS=$(ifconfig | awk '/inet /&&!/127.0.0.1/{print $2}')

echo "Waiting for Network..."

while [[ "$NETWORKSTATUS" == "127.0.0.1" ]] || [[ "$NETWORKSTATUS" == "0.0.0.0" ]] || [[ "$NETWORKSTATUS" == "169.*" ]]
do
  echo "network is not loaded. Waiting."
  sleep 2
  NETWORKSTATUS=$(ifconfig | awk '/inet /&&!/127.0.0.1/{print $2}')
done

sleep 2
echo "Network is up, IP address is $NETWORKSTATUS"

###################################
# Wait until user is fully loaded #
###################################

DOCKSTATUS=$(pgrep -x Dock)

echo "Waiting for Desktop..."

while [[ "$DOCKSTATUS" == "" ]]
do
  echo "Desktop is not loaded. Waiting."
  sleep 2
  DOCKSTATUS=$(pgrep -x Dock)
done

sleep 2

############################################
# Get logged in user after fully signed in #
############################################

LOGGED_IN_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
    echo "$LOGGED_IN_USER has successfully logged on!"

#################################################################################
# Check to see if swiftDialog is installed, and if not, install via Jamf policy #
#################################################################################

if [ -e $DIALOG_APP ]

then

	echo "swiftDialog is installed"

else

	echo "Installing swiftDialog"

	$JAMF_BINARY policy -event install-swiftdialog

fi

#############################
# If admin user, do nothing #
#############################

if [ $LOGGED_IN_USER = admin ]

then

    echo "Management user logged in. Not configuring for individual user."
    $DIALOG_APP  -t "Wipe and Re-enroll" -i "$FAILICON"  --iconsize 500 --centericon -m "admin cannot be the first user to log in. Wipe and re-enroll this Macbook" --messagealignment center --blurscreen
    # Delete setup script
    rm "/Library/Scripts/dep-user-config.sh"
    exit 0

else

    echo "Normal user, continuing"

fi

###################
# App Common Name #
###################

APP1=""
APP2=""
APP3=""
APP4=""
APP5=""
APP6=""
APP7=""
APP8=""
APP9=""
APP10=""
APP11=""
APP12=""
APP13=""
APP14=""
APP15=""

#############################################
# Path to check if app is already installed #
#############################################

PATH1=""
PATH2=""
PATH3=""
PATH4=""
PATH5=""
PATH6=""
PATH7=""
PATH8=""
PATH9=""
PATH10=""
PATH11=""
PATH12=""
PATH13=""
PATH14=""
PATH15=""

#######################
# Jamf Custom Trigger #
#######################

INSTALLCMD1=""
INSTALLCMD2=""
INSTALLCMD3=""
INSTALLCMD4=""
INSTALLCMD5=""
INSTALLCMD6=""
INSTALLCMD7=""
INSTALLCMD8=""
INSTALLCMD9=""
INSTALLCMD10=""
INSTALLCMD11=""
INSTALLCMD12=""
INSTALLCMD13=""
INSTALLCMD14=""
INSTALLCMD15=""

#############
# Icon Path #
#############

ICON1=""
ICON2=""
ICON3=""
ICON4=""
ICON5=""
ICON6=""
ICON7=""
ICON8=""
ICON9=""
ICON10=""
ICON11=""
ICON12=""
ICON13=""
ICON14=""
ICON15=""

###################
# Installing Text #
###################

DIALOG_STEPS=(
    "\"${APP1}\""
    "\"${APP2}\""
    "\"${APP3}\""
    "\"${APP4}\""
    "\"${APP5}\""
    "\"${APP6}\""
    "\"${APP7}\""
    "\"${APP8}\""
    "\"${APP9}\""
    "\"${APP10}\""
    "\"${APP11}\""
    "\"${APP12}\""
    "\"${APP13}\""
    "\"${APP14}\""
    "\"${APP15}\""
)
DIALOG_STEP_LENGTH="${#DIALOG_STEPS[@]}"
DIALOG_STEP=0

#######################
# Main Dialog command #
#######################

DIALOG_CMD=(
    "--title \"$DIALOG_INITIAL_TITLE\""
    "--icon \"$DIALOG_ICON\""
    "--message \"$DIALOG_INITIAL_MESSAGE\""
    "--position center"
    "--blurscreen"
    "--button1disabled"
    "--width 80%"
    "--height 80%"
    "--quitkey x"
    "${DIALOG_STEPS[@]/#/--listitem }"
)

echo_logger() {
    LOG_FOLDER="${LOG_FOLDER:=/private/var/log}"
    LOG_NAME="${LOG_NAME:=log.log}"

    mkdir -p $LOG_FOLDER

    echo -e "$(date) - $1" | tee -a $LOG_FOLDER/$LOG_NAME
}

dialog_update() {
    echo_logger "DIALOG: $1"
    # shellcheck disable=2001
    echo "$1" >> "$DIALOG_COMMAND_FILE"
}

################
# Success Text #
################

dialog_finalise() {
    dialog_update "progresstext: ${APP1} Install Complete"
    dialog_update "progresstext: ${APP2} Install Complete"
    dialog_update "progresstext: ${APP3} Install Complete"
    dialog_update "progresstext: ${APP4} Install Complete"
    dialog_update "progresstext: ${APP5} Install Complete"
    dialog_update "progresstext: ${APP6} Install Complete"
    dialog_update "progresstext: ${APP7} Install Complete"
    dialog_update "progresstext: ${APP8} Install Complete"
    dialog_update "progresstext: ${APP9} Install Complete"
    dialog_update "progresstext: ${APP10} Install Complete"
    dialog_update "progresstext: ${APP11} Install Complete"
    dialog_update "progresstext: ${APP12} Install Complete"
    dialog_update "progresstext: ${APP13} Install Complete"
    dialog_update "progresstext: ${APP14} Install Complete"
    dialog_update "progresstext: ${APP15} Install Complete"
    sleep 1
    # Remove verification packages if any
    #rm "$PATH1"
    #rm "$PATH2"
    #rm "$PATH3"
    #rm "$PATH4"
    #rm "$PATH5"
    #rm "$PATH6"
    #rm "$PATH7"
    #rm "$PATH8"
    #rm "$PATH9"
    #rm "$PATH10"
    #rm "$PATH11"
    #rm "$PATH12"
    #rm "$PATH13"
    #rm "$PATH14"
    #rm "$PATH15"
    dialog_update "quit:"
    # If the script got this far, success!
    $DIALOG_APP -t "$SUCCESSTITLE" -i "$SUCCESSICON" --iconsize 500 --centericon -m "$SUCCESSDESC" --messagefont size=30 --messagealignment center --blurscreen --width 80% --height 80% --quitkey x --timer 10
}

get_json_value() {
    JSON="$1" osascript -l 'JavaScript' \
        -e 'const env = $.NSProcessInfo.processInfo.environment.objectForKey("JSON").js' \
        -e "JSON.parse(env).$2"
}

rm "$DIALOG_COMMAND_FILE"
eval "$DIALOG_APP" "${DIALOG_CMD[*]}" & sleep 1

for (( i=0; i<DIALOG_STEP_LENGTH; i++ )); do
    dialog_update "listitem: index: $i, status: pending"
done

###########################################################
# Installing Apps #########################################
###########################################################

###########################################################
# After installation, will check if Jamf policy completed #
# Checks app path or receipt path #########################
###########################################################

# App1 ########################################################################################

if [ -e "$PATH1" ]; then
        echo "$APP1 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON1", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD1"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH1" ]

then

    echo "$INSTALLCMD1 Success"

else

    echo "Failed on $INSTALLCMD1"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP1**,' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App2 ########################################################################################

if [ -e "$PATH2_1" ] || [ -e "$PATH2_2" ] || [ -e "$PATH2_3" ]; then
        echo "$APP2 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON2", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD2"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH2_1" ] || [ -e "$PATH2_2" ] || [ -e "$PATH2_3" ]

then

    echo "$INSTALLCMD2 Success"

else

    echo "Failed on $INSTALLCMD2"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP2,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0
fi

fi

# App3 ########################################################################################

if [ -e "$PATH3" ]; then
    echo "$APP3 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON3", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD3"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH3" ]

then

    echo "$INSTALLCMD3 Success"

else

    echo "Failed on $INSTALLCMD3"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP3,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App4 ########################################################################################

if [ -e "$PATH4" ]; then
    echo "$APP4 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON4", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD4"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH4" ]

then

    echo "$INSTALLCMD4 Success"

else

    echo "Failed on $INSTALLCMD4"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP4,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App5 ########################################################################################

if [ -e "$PATH5" ]; then
    echo "$APP5 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON5", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD5"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH5" ]

then

    echo "$INSTALLCMD5 Success"

else

    echo "Failed on $INSTALLCMD5"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP5,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App6 ########################################################################################

if [ -e "$PATH6" ]; then
    echo "$APP6 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON6", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD6"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH6" ]

then

    echo "$INSTALLCMD6 Success"

else

    echo "Failed on $INSTALLCMD6"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP6,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App7 ########################################################################################

if [ -e "$PATH7" ]; then
    echo "$APP7 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON7", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD7"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH7" ]

then

    echo "$INSTALLCMD7 Success"

else

    echo "Failed on $INSTALLCMD7"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP7,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App8 ########################################################################################

if [ -e "$PATH8" ]; then
    echo "$APP8 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON8", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD8"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH8" ]

then

    echo "$INSTALLCMD8 Success"

else

    echo "Failed on $INSTALLCMD8"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP8,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App9 ########################################################################################

if [ -e "$PATH9" ]; then
    echo "$APP9 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON9", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD9"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH9" ]

then

    echo "$INSTALLCMD9 Success"

else

    echo "Failed on $INSTALLCMD9"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP9,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App10 ########################################################################################

if [ -e "$PATH10" ]; then
    echo "$APP10 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON10", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD10"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH10" ]

then

    echo "$INSTALLCMD10 Success"

else

    echo "Failed on $INSTALLCMD10"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP10,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App11 ########################################################################################

if [ -e "$PATH11" ]; then
    echo "$APP11 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON11", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD11"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH11" ]

then

    echo "$INSTALLCMD11 Success"

else

    echo "Failed on $INSTALLCMD11"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP11,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App12 ########################################################################################

if [ -e "$PATH12" ]; then
    echo "$APP12 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON12", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD12"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH12" ]

then

    echo "$INSTALLCMD12 Success"

else

    echo "Failed on $INSTALLCMD12"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP12,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App13 ########################################################################################

if [ -e "$PATH13" ]; then
    echo "$APP13 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON13", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD13"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH13" ]

then

    echo "$INSTALLCMD13 Success"

else

    echo "Failed on $INSTALLCMD13"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP13,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App14 ########################################################################################

if [ -e "$PATH14" ]; then
    echo "$APP14 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON14", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD14"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH14" ]

then

    echo "$INSTALLCMD14 Success"

else

    echo "Failed on $INSTALLCMD14"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP14,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

# App15 ########################################################################################

if [ -e "$PATH15" ]; then
    echo "$APP15 already installed"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"
else

    dialog_update "listitem: index: $((DIALOG_STEP)), "icon": "$ICON15", status: wait"

    "$JAMF_BINARY" policy -event "$INSTALLCMD15"
    dialog_update "listitem: index: $((DIALOG_STEP++)), status: success"

if [ -e "$PATH15" ]

then

    echo "$INSTALLCMD15 Success"

else

    echo "Failed on $INSTALLCMD15"
    dialog_update "quit:"
    sleep 1
    $DIALOG_APP -t "$FAILTITLE" -i "$FAILICON"  --iconsize 500 --centericon -m "Script failed at '**$APP15,**' please press command+X and try again from self service. Search for 'DEP User Config Script'" --messagefont size=30 -f --button1disabled --position center --quitkey x
    exit 0

fi

fi

#########################################################################################

sleep 1
dialog_finalise

exit 0
