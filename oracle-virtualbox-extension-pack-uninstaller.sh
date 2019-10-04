#!/usr/bin/env bash

# DESCRIPTION
# -----------
# Checks for the 'Oracle VM VirtualBox Extension Pack' and uninstalls it if
# found.
#
# SUPPORTED SYSTEMS
# -----------------
# This script was written to support macOS as well as various Unix and Linux
# operating systems, however it has only been tested on macOS so far.
#
# USAGE
# -----
# Simply execute this script.
#
# NOTE: On macOS, if not run as root, the user is prompted for their password.
#
# LICENSE
# -------
# Copyright 2019 J. Brandt Buckley
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# NOTICE
# ----------
# This project is not endorsed by, directly affiliated with, maintained,
# authorized, or sponsored by Oracle, or any of its subsidiaries or its
# affiliates. Oracle and Java are registered trademarks of Oracle and/or
# its affiliates. Other names may be trademarks of their respective owners.
#

if command -v VBoxManage &>/dev/null ; then
  VBOXMANAGE=$(command -v VBoxManage)
elif [ -x "/Applications/VirtualBox.app/Contents/MacOS/VBoxManage" ]; then
  VBOXMANAGE="/Applications/VirtualBox.app/Contents/MacOS/VBoxManage"
elif [ -x "/usr/local/bin/vboxmanage" ]; then
  VBOXMANAGE="/usr/local/bin/vboxmanage"
elif [ -x "/usr/local/bin/VBoxManage" ]; then
  VBOXMANAGE="/usr/local/bin/VBoxManage"
elif [ -x "/usr/bin/VBoxManage" ]; then
  VBOXMANAGE="/usr/bin/VBoxManage"
elif [ -x "/usr/bin/vboxmanage" ]; then
  VBOXMANAGE="/usr/bin/vboxmanage"
elif [ -x "/usr/local/lib/virtualbox/VBoxManage" ]; then
  VBOXMANAGE="/usr/local/lib/virtualbox/VBoxManage"
elif [ -x "/usr/local/lib64/virtualbox/VBoxManage" ]; then
  VBOXMANAGE="/usr/local/lib64/virtualbox/VBoxManage"
elif [ -x "/usr/lib/virtualbox/VBoxManage" ]; then
  VBOXMANAGE="/usr/lib/virtualbox/VBoxManage"
elif [ -x "/usr/lib64/virtualbox/VBoxManage" ]; then
  VBOXMANAGE="/usr/lib64/virtualbox/VBoxManage"
else
  echo "INFO: VBoxManage executable not found. VirtualBox probably is not installed."
fi

# known_extension_pack_path_exists check if the extension pack exists at any
# of known paths to which it might have been installed. It returns with status
# code 0 if found, and a non-zer status code if not.
known_extension_pack_path_exists() {
  test -e "/Applications/VirtualBox.app/Contents/MacOS/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack" \
    -o -e "/usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack" \
    -o -e "/usr/lib64/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack" \
    -o -e "/usr/local/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack" \
    -o -e "/usr/local/lib64/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack"
}

# extension_pack_installed tests whether the Oracle VM VirtualBox Extension
# Pack has been installed. It returns with status code 0 if an installation
# was found, and a non-zero status code if one was not.
extension_pack_installed() {
  known_extension_pack_path_exists && return 0

  if [ -z "$VBOXMANAGE" ]; then
    # If the extension was not installed to a known path and we can't find the
    # VBoxManage command-line tool, we've exhausted all the ways we know how
    # to find the extension.
    return 1
  fi

  # Example `VBoxManage list extpacks` output:
  #
  #   $ VBoxManage list extpacks
  #   Extension Packs: 1
  #   Pack no. 0:   Oracle VM VirtualBox Extension Pack
  #   Version:      6.0.12
  #   Revision:     133076
  #   Edition:
  #   Description:  USB 2.0 and USB 3.0 Host Controller, Host Webcam, VirtualBox RDP, PXE ROM, Disk Encryption, NVMe.
  #   VRDE Module:  VBoxVRDP
  #   Usable:       true
  #   Why unusable:

  $VBOXMANAGE list extpacks | grep -q "Oracle VM VirtualBox Extension Pack"
}

echo "INFO: Checking for 'Oracle VM VirtualBox Extension Pack' installation..."
if extension_pack_installed ; then
  echo "INFO: Detected Oracle VM VirtualBox Extension Pack."
else
  echo "INFO: Oracle VM VirtualBox Extension Pack not found. Exiting..."
  exit 0
fi

if [ -z "$VBOXMANAGE" ]; then
  echo "ERROR: Unable to uninstall extension pack because a VBoxManage executable could not be found."
  exit 2
fi

$VBOXMANAGE extpack uninstall --force "Oracle VM VirtualBox Extension Pack"
$VBOXMANAGE extpack cleanup

if extension_pack_installed ; then
  echo "ERROR: Oracle VM VirtualBox Extension Pack was still detected after uninstall. Either the uninstall failed or there are multiple instances installed."
  exit 2
fi
echo "INFO: Oracle VM VirtualBox Extension Pack no longer found."
