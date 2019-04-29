#!/bin/bash
#
# Setup repositories
#

APT_SRC_DIR="/etc/apt/sources.list.d"

add_google_cloud_sdk() {
    # Add Google Cloud SDK repo
    REPO="google-cloud-sdk.list"
    KEY_URL="https://packages.cloud.google.com/apt/doc/apt-key.gpg"
    if [ ! -f $APT_SRC_DIR/$REPO ]; then
        echo "--> Adding google-cloud-sdk repo (apt)"
        #CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
        CLOUD_SDK_REPO="cloud-sdk-cosmic" # hardcode cosmic, no sdk repo for dicso yet
        SOURCE="deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main"
        echo "$SOURCE" | sudo tee -a $APT_SRC_DIR/$REPO &>/dev/null
        echo -n "--> Importing Key from : $KEY_URL "
        curl --silent $KEY_URL | sudo apt-key add -
    fi
}

add_google_chrome() {
    # Add Google Chrome SDK repo
    REPO="google-chrome.list"
    KEY_URL="https://dl.google.com/linux/linux_signing_key.pub"
    if [ ! -f $APT_SRC_DIR/$REPO ]; then
        echo "--> Adding google-chrome repo (apt)"
        SOURCE="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" 
        echo "$SOURCE" | sudo tee -a $APT_SRC_DIR/$REPO &>/dev/null
        echo -n "--> Importing Key from : $KEY_URL "
        curl --silent $KEY_URL | sudo apt-key add -
    fi
}

add_google_cloud_sdk
add_google_chrome
sudo apt update
