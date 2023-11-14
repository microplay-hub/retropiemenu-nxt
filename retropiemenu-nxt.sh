#!/usr/bin/env bash

# This file is part of the microplay-hub
# Designs by Liontek1985
# for RetroPie and offshoot
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
# retropiemenu for RaspberryPi, OrangePi v1.4 - 2023-11-14

rp_module_id="retropiemenu-nxt"
rp_module_desc="RetroPie configuration menu for EmulationStation"
rp_module_repo="git https://github.com/microplay-hub/retropiemenu-nxt.git master"
rp_module_section="core"
rp_module_flags="noinstclean"

function _update_hook_retropiemenu-nxt() {
    # to show as installed when upgrading to retropie-setup 4.x
    if ! rp_isInstalled "$md_id" && [[ -f "$home/.emulationstation/gamelists/retropie/gamelist.xml" ]]; then
        mkdir -p "$md_inst"
        # to stop older scripts removing when launching from retropie menu in ES due to not using exec or exiting after running retropie-setup from this module
        touch "$md_inst/.retropie"
    fi
}

function depends_retropiemenu-nxt() {
    local depends=(cmake)
     getDepends "${depends[@]}"
}

function _update_hook_retropiemenu-nxt() {
    renameModule "retropiemenu-opi" "retropiemenu-nxt"
}

function sources_retropiemenu-nxt() {
    if [[ -d "$md_inst" ]]; then
        git -C "$md_inst" reset --hard  # ensure that no local changes exist
    fi
    gitPullOrClone "$md_inst"
}

function install_retropiemenu-nxt() {
    local rpmsetup="$scriptdir/scriptmodules/supplementary"
	
    cd "$md_inst"
	
#	cp -r "retropiemenu-nxt.sh" "$rpmsetup/retropiemenu-nxt.sh"
    chown -R $user:$user "$rpmsetup/retropiemenu-nxt.sh"
	chmod 755 "$rpmsetup/retropiemenu-nxt.sh"
	rm -r "retropiemenu-nxt.sh"
	
}

function configure_retropiemenu-nxt()
{
    [[ "$md_mode" == "remove" ]] && return

    local rpdir="$home/RetroPie/retropiemenu-nxt"
    mkdir -p "$rpdir"
    cp -Rv "$md_inst/icons_modern" "$rpdir/icons"
    chown -R $user:$user "$rpdir"
	chmod 755 "$rpdir/icons"

    isPlatform "rpi" && rm -f "$rpdir/dispmanx.rp"

    # add the gameslist / icons
    local files=(
        'audiosettings'
        'bluetooth'
        'configedit'
        'esthemes'
        'mpthemes'
        'filemanager'
        'raspiconfig'
        'orangepiconfig'
        'armbianconfig'		
        'retroarch'
        'retronetplay'
        'rpsetup'
        'runcommand'
        'log'
        'showip'
        'splashscreen'
        'splashscreen-opi'
        'opiwifi'
        'wifi'
    )

    local names=(
        'Audio'
        'Bluetooth'
        'Configuration Editor'
        'ES Themes'
        'MP Themes'
        'File Manager'
        'Raspi-Config'
        'Orangepi-Config'
        'Armbian-Config'
        'Retroarch'
        'RetroArch Net Play'
        'RetroPie Setup'
        'Run Command Configuration'
        'Run Command Logs'
        'Show IP'
        'Splash Screens'
        'Splash Screens OPI'
        'On Board WiFi'
        'WiFi'
    )

    local descs=(
        'Configure audio settings. Choose default of auto, 3.5mm jack, or HDMI. Mixer controls, and apply default settings.'
        'Register and connect to Bluetooth devices. Unregister and remove devices, and display registered and connected devices.'
        'Change common RetroArch options, and manually edit RetroArch configs, global configs, and non-RetroArch configs.'
        'Install, uninstall, or update EmulationStation themes. Most themes can be previewed at https://retropie.org.uk/docs/Themes/.'
        'Install, uninstall, or update Microplay-hub EmulationStation themes.'
        'Basic ASCII file manager for Linux allowing you to browse, copy, delete, and move files.'
        'Change user password, boot options, internationalization, camera, add your Pi to Rastrack, overclock, overscan, memory split, SSH and more.'
        'Change user password, boot options, internationalization, camera, overclock, overscan, memory split, SSH and more.'
        'Armbian Change user password, boot options, internationalization, camera, overclock, overscan, memory split, SSH and more.'
        'Launches the RetroArch GUI so you can change RetroArch options. Note: Changes will not be saved unless you have enabled the "Save Configuration On Exit" option.'
        'Set up RetroArch Netplay options, choose host or client, port, host IP, delay frames, and your nickname.'
        'Install RetroPie from binary or source, install experimental packages, additional drivers, edit Samba shares, custom scraper, as well as other RetroPie-related configurations.'
        'Change what appears on the runcommand screen. Enable or disable the menu, enable or disable box art, and change CPU configuration.'
        'Show last Runcommand Logfile'
        'Displays your current IP address, as well as other information provided by the command "ip addr show."'
        'Enable or disable the splashscreen on RetroPie boot. Choose a splashscreen, download new splashscreens, and return splashscreen to default.'
        'Enable or disable the splashscreen on RetroPie boot for OrangePi. Choose a splashscreen, download new splashscreens, and return splashscreen to default.'
        'Connect to or disconnect from a WiFi network and configure OnBoard WiFi settings.'
        'Connect to or disconnect from a WiFi network and configure WiFi settings.'
    )

    setESSystem "RetroPie" "retropie" "$rpdir" ".rp .sh" "sudo $scriptdir/retropie_packages.sh retropiemenu-nxt launch %ROM% </dev/tty >/dev/tty" "" "retropie"

    local file
    local name
    local desc
    local image
    local i
    for i in "${!files[@]}"; do
		
        file="${files[i]}"
        name="${names[i]}"
        desc="${descs[i]}"
        image="$home/RetroPie/retropiemenu-nxt/icons/${files[i]}.png"

        touch "$rpdir/$file.rp"

        local function
        for function in $(compgen -A function _add_rom_); do
            "$function" "retropie" "RetroPie" "$file.rp" "$name" "$desc" "$image"
        done
    done
	platform_retropiemenu-nxt
}


function platform_retropiemenu-nxt() {

    if isPlatform "sun50i-h616"; then
		local rpdir="$datadir/retropiemenu-nxt"
		rm -r "$rpdir/wifi.rp"
		rm -r "$rpdir/raspiconfig.rp"
		rm -r "$rpdir/splashscreen.rp"
		rm -r "$rpdir/audiosettings.rp"
		rm -r "$rpdir/armbianconfig.rp"
    elif isPlatform "sun50i-h6"; then
		local rpdir="$datadir/retropiemenu-nxt"
		rm -r "$rpdir/wifi.rp"
		rm -r "$rpdir/raspiconfig.rp"
		rm -r "$rpdir/splashscreen.rp"
		rm -r "$rpdir/audiosettings.rp"
		rm -r "$rpdir/armbianconfig.rp"
    elif isPlatform "sun8i-h3"; then
		local rpdir="$datadir/retropiemenu-nxt"
		rm -r "$rpdir/wifi.rp"
		rm -r "$rpdir/raspiconfig.rp"
		rm -r "$rpdir/splashscreen.rp"
		rm -r "$rpdir/audiosettings.rp"
		rm -r "$rpdir/orangepiconfig.rp"
    elif isPlatform "armv7-mali"; then
		local rpdir="$datadir/retropiemenu-nxt"
		rm -r "$rpdir/wifi.rp"
		rm -r "$rpdir/raspiconfig.rp"
		rm -r "$rpdir/splashscreen.rp"
		rm -r "$rpdir/audiosettings.rp"
		rm -r "$rpdir/orangepiconfig.rp"
	elif isPlatform "rpi"; then
		local rpdir="$datadir/retropiemenu-nxt"
		rm -r "$rpdir/opiwifi.rp"
		rm -r "$rpdir/splashscreen-opi.rp"
		rm -r "$rpdir/armbianconfig.rp"
		rm -r "$rpdir/orangepiconfig.rp"
    fi
}
	

function remove_retropiemenu-nxt() {
    rm -rf "$home/RetroPie/retropiemenu-nxt"
    rm -rf "$home/.emulationstation/gamelists/retropie"
	rm -rf "$md_inst"
    delSystem retropie
}

function launch_retropiemenu-nxt() {
    clear
    local command="$1"
    local basename="${command##*/}"
    local no_ext="${basename%.rp}"
    joy2keyStart
    case "$basename" in
        retroarch.rp)
            joy2keyStop
            cp "$configdir/all/retroarch.cfg" "$configdir/all/retroarch.cfg.bak"
            chown $user:$user "$configdir/all/retroarch.cfg.bak"
            su $user -c "XDG_RUNTIME_DIR=/run/user/$SUDO_UID \"$emudir/retroarch/bin/retroarch\" --menu --config \"$configdir/all/retroarch.cfg\""
            iniConfig " = " '"' "$configdir/all/retroarch.cfg"
            iniSet "config_save_on_exit" "false"
            ;;
        rpsetup.rp)
            rp_callModule setup gui
            ;;
        raspiconfig.rp)
            raspi-config
            ;;
        orangepiconfig.rp)
            orangepi-config
            ;;
        armbianconfig.rp)
            armbian-config
            ;;
        filemanager.rp)
            mc
            ;;
        opiwifi.rp)
            sudo nmtui
            ;;
		log.rp)
            printMsgs "dialog" "Your runcommand.log is:\n\n$(cat /dev/shm/runcommand.log)"
            ;;
        showip.rp)
            local ip="$(getIPAddress)"
            printMsgs "dialog" "Your IP is: ${ip:-(unknown)}\n\nOutput of 'ip addr show':\n\n$(ip addr show)"
            ;;
        *.rp)
            rp_callModule $no_ext depends
            if fnExists gui_$no_ext; then
                rp_callModule $no_ext gui
            else
                rp_callModule $no_ext configure
            fi
            ;;
        *.sh)
            cd "$home/RetroPie/retropiemenu-nxt"
            sudo -u "$user" bash "$command"
            ;;
    esac
    joy2keyStop
    clear
}
function gui_retropiemenu-nxt() {

    while true; do
		
        local options=(	
            1 "Add armbian-config to Retropiemenu"
            2 "Add orangepi-config to Retropiemenu"
            3 "Add raspi-config to Retropiemenu"
            4 "Add Orangepi-WiFi to Retropiemenu"
			5 "Add Raspberry-Pi-WiFi to Retropiemenu"
			6 "Add Raspberry-Audiosettings to Retropiemenu"
        )
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Choose an option" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            1)
		touch "$datadir/retropiemenu-nxt/armbianconfig.rp"
		chown "$datadir/retropiemenu-nxt/armbianconfig.rp"
                printMsgs "dialog" "armbianconfig added"
                ;;
            2)
		touch "$datadir/retropiemenu-nxt/orangepiconfig.rp"
		chown "$datadir/retropiemenu-nxt/orangepiconfig.rp"
                printMsgs "dialog" "orangepiconfig added"
                ;;
            3)
		touch "$datadir/retropiemenu-nxt/raspiconfig.rp"
		chown "$datadir/retropiemenu-nxt/raspiconfig.rp"
                printMsgs "dialog" "raspiconfig added"
                ;;
            4)
		touch "$datadir/retropiemenu-nxt/opiwifi.rp"
		chown "$datadir/retropiemenu-nxt/opiwifi.rp"
                printMsgs "dialog" "OnBoard WiFi for OrangePi added."
                ;;
            5)
		touch "$datadir/retropiemenu-nxt/wifi.rp"
		chown "$datadir/retropiemenu-nxt/wifi.rp"
                printMsgs "dialog" "Raspberry-Pi-WiFi added."
                ;;
            6)
		touch "$datadir/retropiemenu-nxt/audiosettings.rp"
		chown "$datadir/retropiemenu-nxt/audiosettings.rp"
                printMsgs "dialog" "Raspberry-Pi Audiosettings added."
                ;;
        esac
    done
}
