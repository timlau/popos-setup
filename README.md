# Setup Script for Pop!_OS 19.04
This script automate installation of repos, packages, flatpak and Gnome Extentions to your Pop!_OS 19.04 (disco) system

Uses the following script to install gnome extentions : https://github.com/brunelli/gnome-shell-extension-installer

Add the packages to install to packages.lst
Add the Flatpak's to install to flatpaks.lst
Add the Gnome shell extentions to gnome-extentions.lst

Modify the repo-setup.sh to add extra sources, if needed

## Installation

```sh
wget https://github.com/timlau/popos-setup/archive/master.zip
unzip master.zip
cd popos-setup-master/
```

## Usage

* Edit the packages.lst files to contain the package you want to have installed
* Edit the flatpaks.lst to contain the flatpak's you want to have installed (get names from https://flathub.org)
* Edit the gnome-extention.lst to contain the extention url you want to install (from https://extensions.gnome.org/)
* Optional edit repo-setup.sh to add extra sources (check example for google-cloud-sdk)
* if you don't want to install any packages, flatpak or gnome extention, then just delete or rename the .lst file
* if you temporary what to skip an element in an .lst file just add # in the start of the line

```sh
./setup-pop.sh
```

