#!/bin/bash
#   Part of Setup script for Pop OS 19.04 (setup-pop.sh)
#   Copyright 2019 by Tim Lauridsen <tla AT rasmil.dk>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

#
# This script setop additional apt sources and initialize the apt cache
# each source is implemted as a function, you disable adding the source by 
# comment out the add_xxxxxxxx line

APT_SRC_DIR="/etc/apt/sources.list.d"

# Add source and import key for Google Cloud Platform SDK
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

# Add source and import key for Google Chrome (stable)
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

# comment out add_xxxxxxx lines to avoid adding them
add_google_cloud_sdk
add_google_chrome
sudo apt update
