{
  ...
}: {
  gtk = {
    enable = true;

    gtk3 = {
      extraCss = ''
        window.background {
          background-color: rgba(26, 27, 38, 0.85);
        }
      '';
    };

    gtk4 = {
      extraCss = ''
        window.background {
          background-color: rgba(26, 27, 38, 0.85);
        }
      '';
    };
  };
}
