{
  services.kanata = {
    enable = true;

    keyboards = {
      default = {
        extraDefCfg = "concurrent-tap-hold yes";

        config = ''
          (defsrc
            esc  caps  lalt  lmet  rmet  ralt  f  j
          )

          (deflayer base
            esc  @caps-esc-ctrl  lmet  lalt  ralt  rmet  f  j
          )

          (defalias
            caps-esc-ctrl (tap-hold-press 200 200 esc lctl)
          )

          (defchordsv2
            (f j) bspc 50 first-release ()
          )
        '';
      };
    };
  };
}
