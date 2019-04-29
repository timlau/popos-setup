#!/bin/bash
# Setup script for Pop OS 19.04

# install packages if not installed already
# install "package" "extrapkg1 extrapkg2 .. "

add_repos () {
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
}

pkg_install () {
    color_label="\e[32m$1\e[00m"
    dpkg -l | grep -qw $1; 
    if [ $? -eq 0 ] ; then
        echo -e "--> Skipping $color_label (already installed)"
        return 0;
    else
        echo -e "--> Installing $color_label "
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq $1 $2 < /dev/null > /dev/null  
        return 1;
    fi
}

# Install flatpaks
fp_install () {
    color_label="\e[32m$1\e[00m"
    echo -e "--> Installing $color_label"
    echo -n -e "    \e[94m"
    flatpak install -y --noninteractive $1
    echo -n -e "\e[00m"
}

print_hdr () {
    echo "===================================================================="
    echo " $1"
    echo "===================================================================="
}

start_flatpaks () {
    #Install flatpak support and add flathub repo
    print_hdr "Installing flatpaks"
    pkg_install "flatpak" "gnome-software-plugin-flatpak"
    echo "--> Adding flathub repo"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}



ge_install () {
    if [ ! -x gnome-shell-extension-installer ]; then
        wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
        chmod +x gnome-shell-extension-installer
    fi
    id=$(echo $1 | cut -d "/" -f 5 -)
    name=$(echo $1 | cut -d "/" -f 6 -)
    color_label="\e[32m$name ($id)\e[00m"
    echo -e "--> Installing $color_label"
    (IFS='
'
    for i in $(./gnome-shell-extension-installer $id --yes --update)
    do
        echo -e "    \e[94m$i"
    done)
    echo -n -e "\e[00m"  
}

# Packages to install
print_hdr "Setup repos"
add_repos
print_hdr "Installing packages"
pkg_install "htop"
pkg_install "virtualbox" "virtualbox-guest-additions-iso virtualbox-ext-pack"
pkg_install "vlc"
pkg_install "gitg"
pkg_install "google-cloud-sdk"
pkg_install "inkscape"
pkg_install "darktable"
pkg_install "handbrake"
pkg_install "code"


# Flatpak's to install
start_flatpaks
fp_install "org.gimp.GIMP"
fp_install "org.olivevideoeditor.Olive"

# Install gnome extensions
print_hdr "Installing Gnome Extension"
ge_install "https://extensions.gnome.org/extension/307/dash-to-dock/"
ge_install "https://extensions.gnome.org/extension/545/hide-top-bar/"


