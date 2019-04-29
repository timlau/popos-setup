#!/bin/bash
#
# Setup repositories
#

APT_SRC_DIR="/etc/apt/sources.list.d"
# Add Google Cloud SDK repo
GOOGLE_CLOUD_REPO="google-cloud-sdk.list"
if [ ! -f $APT_SRC_DIR/$GOOGLE_CLOUD_REPO ]; then
    echo "--> Adding google-cloud-sdk repo (apt)"
    #CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
    CLOUD_SDK_REPO="cloud-sdk-cosmic" # hardcode cosmic, no sdk repo for dicso yet
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a $APT_SRC_DIR/$GOOGLE_CLOUD_REPO
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
fi
sudo apt update
