{
  services.kanata = {
    enable = true;

    keyboards = {
      default = {
        extraDefCfg = "concurrent-tap-hold yes";

        config = ''
          (defsrc
            esc  caps  spc  lalt  lmet  ralt  rmet  f  j
          )

          (deflayer base
            caps  esc  @spc-ctrl  lmet  lalt  rmet  ralt  f  j
          )

          (defalias
            spc-ctrl (tap-hold-press 200 200 spc lctl)
          )

          (defchordsv2
            (f j) bspc 50 first-release ()
          )
        '';
      };
    };
  };
}
