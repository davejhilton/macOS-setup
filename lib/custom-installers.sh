#! /usr/bin/env bash

##########################################
#                                        #
#   DaveH: Custom Installer Functions    #
#                                        #
##########################################

# shellcheck disable=SC2155


# Custom installer for installing a .pkg file from a URL
# Parameters: $1 (required) - URL, $2 (required) - Application Name
install_pkg_url() {
  local url="$1"
  local app_name="$2"
  local work_file="download.pkg"
  download_file "$url" "$work_file"
  install_pkg "$MAC_OS_WORK_PATH" "$app_name"
  verify_application "$app_name"
}
export -f install_pkg_url


# Custom installer for installing apps with an already-downloaded local DMG file
# Parameters: $1 (required) - DMG File Path, $2 (required) - Volume Name, $3 (required) - Application Name
install_local_dmg_app() {
  local dmg_file_path="$1"
  local mount_point="/Volumes/$2"
  local app_name="$3"
  local install_path=$(get_install_path "$app_name")

  if [[ ! -e "$install_path" ]]; then
    local install_root=$(get_install_root "$app_name")
    mount_image "$dmg_file_path"
    printf "Installing: %s/%s...\n" "$install_root" "$app_name"
    cp -a "$mount_point/$app_name" "$install_root"
    unmount_image "$mount_point"
    verify_application "$app_name"
  fi
}
export -f install_local_dmg_app


# Custom installer for when a *LOCAL* DMG contains the App within a *NESTED* folder, instead of at the top level
# Parameters: $1 (required) - DMG File Path, $2 (required) - Volume Name, $3 (required) - Nested Path to App, $4 (required) - Application Name
install_local_dmg_nested_app() {
  local dmg_file_path="$1"
  local mount_point="/Volumes/$2"
  local nested_path="$3"
  local app_name="$4"
  local install_path=$(get_install_path "$app_name")

  if [[ ! -e "$install_path" ]]; then
    local install_root=$(get_install_root "$app_name")
    mount_image "$dmg_file_path"
    printf "Installing: %s/%s...\n" "$install_root" "$app_name"
    cp -a "$mount_point/$nested_path" "$install_root"
    unmount_image "$mount_point"
    verify_application "$app_name"
  fi
}
export -f install_local_dmg_nested_app


# Custom installer for when a DMG contains the App within a *NESTED* folder, instead of at the top level.
# Parameters: $1 (required) - DMG URL, $2 (required) - Volume Name, $3 (required) - Nested Path to App, $4 (required) - Application Name
install_dmg_nested_app() {
  download_file "$1" "download.dmg"
  install_local_dmg_nested_app "${MAC_OS_WORK_PATH}/download.dmg" "$2" "$3" "$4"
}
export -f install_dmg_nested_app
