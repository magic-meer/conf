# Non-root access to the RGB keyboard's vendor HID channel.
#
# The lighting interface lives on interface 1 of 258a:0049 and is
# driven with EP0 feature reports through /dev/hidraw*. udev ships
# those nodes as 0600 root:root, so without this rule every lighting
# command needs sudo.
#
# "users" group already contains meher; TAG+=uaccess additionally hands
# an ACL to the active logind seat (covers the SSH case differently).
{
  services.udev.extraRules = ''
    # SINO WEALTH Bluetooth Keyboard (USB) - both interfaces:
    #   00 = boot keyboard (LED output reports)
    #   01 = vendor channel (the RGB feature reports)
    SUBSYSTEM=="hidraw", SUBSYSTEMS=="usb", ATTRS{idVendor}=="258a", ATTRS{idProduct}=="0049", GROUP="users", MODE="0660", TAG+="uaccess"

    # 2.4G dongle (Areson/Compx 25a7:fa70)
    SUBSYSTEM=="hidraw", SUBSYSTEMS=="usb", ATTRS{idVendor}=="25a7", ATTRS{idProduct}=="fa70", GROUP="users", MODE="0660", TAG+="uaccess"
  '';
}
