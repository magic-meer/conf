My very own nixos configurations

the system contains device spercific config, rn there is only "jinnnn", the main machine that i use (this one)
the home dir contains user specific configs, rn there is only "meher", me, no other user exists on this machines so its just me

we follow a modular config structure, wehre each app is configured in its own file under home/meher/ and if has a big config , we further modularize that into a dir, these all user packages must be declared in the home/meher/packages.nix and no other place.
the home/meher/keybind/ is a central place that contains soft sym links to all keybind files for all apps which's keybings are declared this is to easlily find and configure all the keybinds.
