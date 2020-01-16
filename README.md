oracle-virtualbox-extension-pack-uninstaller
============================================

Check for and uninstall the 'Oracle VM VirtualBox Extension Pack'.

WARNING: While this _should_ also support various other Unix and Linux operating systems, so far it has only been tested on macOS.

BACKGROUND
----------

Oracle is [reportedly going after companies][1] it detects are using its proprietary VirtualBox Extension Pack without an Oracle VM VirtualBox Extension Pack Enterprise license.

While the VirtualBox Base Package 6.0 is [licensed under the GPLv2][2], the VirtualBox Extension Pack is provided under a [proprietary license][3]. (Specifics are in their [Licensing FAQ][4].)

This extension pack is offered as a separate download, and adds 'USB 2.0 and USB 3.0 Host Controller, Host Webcam, VirtualBox RDP, PXE ROM, Disk Encryption, NVMe' functionality.

USAGE
-----
Simply execute this script.

NOTE: On macOS, if not run as root, the user is prompted for their password.


[1]: https://www.theregister.co.uk/2019/10/04/oracle_virtualbox_merula/
[2]: https://www.virtualbox.org/wiki/GPL
[3]: https://www.virtualbox.org/wiki/VirtualBox_PUEL
[4]: https://www.virtualbox.org/wiki/Licensing_FAQ

_This project is not endorsed by, directly affiliated with, maintained, authorized, or sponsored by Oracle, or any of its subsidiaries or its affiliates. Oracle and Java are registered trademarks of Oracle and/or its affiliates. Other names may be trademarks of their respective owners._
