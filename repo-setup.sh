#!/bin/bash
#
# Setup repositories
#

APT_SRC_DIR="/etc/apt/sources.list.d"

add_google_cloud_sdk() {
    # Add Google Cloud SDK repo
    GOOGLE_CLOUD_REPO="google-cloud-sdk.list"
    if [ ! -f $APT_SRC_DIR/$GOOGLE_CLOUD_REPO ]; then
        echo "--> Adding google-cloud-sdk repo (apt)"
        #CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
        CLOUD_SDK_REPO="cloud-sdk-cosmic" # hardcode cosmic, no sdk repo for dicso yet
        echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a $APT_SRC_DIR/$GOOGLE_CLOUD_REPO
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    fi
}

add_google_chrome() {
    # Add Google Chrome SDK repo
    GOOGLE_CROME_REPO="google-chrome.list"
    if [ ! -f $APT_SRC_DIR/GOOGLE_CROME_REPO ]; then
        echo "--> Adding google-chrome repo (apt)"
        echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a $APT_SRC_DIR/$GOOGLE_CLOUD_REPO
        curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    fi
}

add_google_cloud_sdk
add_google_chrome
sudo apt update
