#!/bin/bash
# Setup script for Pop OS 19.04

# Install packages if not installed already
pkg_install () {
    pkg=$(echo $1 | cut -d " " -f 1 -)
    other_pkgs=$(echo $1 | cut -d "/" -f 2- -)
    color_label="\e[32m$pkg\e[00m"
    dpkg -l | grep -qw $pkg; 
    if [ $? -eq 0 ] ; then
        echo -e "--> Skipping $color_label (already installed)"
        return 0;
    else
        echo -e "--> Installing $color_label "
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq $pkg $other_pkgs < /dev/null > /dev/null  
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

# Setup for flatpak support
start_flatpaks () {
    #Install flatpak support and add flathub repo
    print_hdr "Installing flatpaks"
    pkg_install "flatpak" "gnome-software-plugin-flatpak"
    echo "--> Adding flathub repo"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# Install gnome extentions
ge_install () {
    if [ ! -x gnome-shell-extension-installer ]; then
        wget -q -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer" 
        chmod +x ./gnome-shell-extension-installer
    fi
    id=$(echo $1 | cut -d "/" -f 5 -)
    name=$(echo $1 | cut -d "/" -f 6 -)
    color_label="\e[32m$name ($id)\e[00m"
    echo -e "--> Installing $color_label"
    IFS=$'\r\n' 
    for i in $(./gnome-shell-extension-installer $id --yes --update)
    do
        echo -e "    \e[94m$i"
    done
    echo -n -e "\e[00m"  
}

# Install Packages
print_hdr "Setup repos"
sh ./repo-setup.sh 
if [ -f packages.lst ]; then
    print_hdr "Installing packages"
    IFS=$'\r\n' GLOBIGNORE='*' command eval 'packages=$(cat packages.lst)'
    for pkg in $packages
    do
        pkg_install $pkg
    done
fi

# Install FlatPak's
if [ -f flatpaks.lst ]; then
    start_flatpaks
    IFS=$'\r\n' GLOBIGNORE='*' command eval 'flatpaks=$(cat flatpaks.lst)'
    for fpak in $flatpaks
    do
        fp_install $fpak
    done
fi

# Install gnome extensions
if [ -f gnome-extentions.lst ]; then
    print_hdr "Installing Gnome Extension"
    IFS=$'\r\n' GLOBIGNORE='*' command eval 'extentions=$(cat gnome-extentions.lst)'
    for ge in $extentions
    do
        ge_install $ge
    done
fi



