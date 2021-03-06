#!/bin/bash
#   Setup script for Pop OS 19.04 
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
./repo-setup.sh 
file="packages.lst"
if [ -f $file ]; then
    print_hdr "Installing packages"
    grep -v -e'^#' -e'^[[:space:]]*$' < "$file" | {
    while IFS= read -r line
    do
        pkg_install $line
    done }
fi

# Install FlatPak's
file="flatpaks.lst"
if [ -f $file ]; then
    start_flatpaks
    grep -v -e'^#' -e'^[[:space:]]*$' < "$file" | {
    while IFS= read -r line
    do
        fp_install $line
    done }
fi

# Install gnome extensions
file="gnome-extentions.lst"
if [ -f $file ]; then
    print_hdr "Installing Gnome Extensions"
    grep -v -e'^#' -e'^[[:space:]]*$' < "$file" | {
    while IFS= read -r line
    do
        ge_install $line
    done }
fi



