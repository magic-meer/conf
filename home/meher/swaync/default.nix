{
  ...
}: {
  home.file = {
    ".config/swaync/config.json".text = builtins.toJSON {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "overlay";
      control-center-margin-top = 10;
      control-center-margin-right = 10;
      control-center-margin-bottom = 10;
      control-center-margin-left = 10;
      notification-window-margin = "10px 10px";
      hide-on-locked = false;
      timeout = 6;
      timeout-low = 3;
      timeout-critical = 0;
      notification-icon-size = 40;
      notification-body-image-width = 200;
      notification-body-image-height = 100;
      widgets = [ "title" "body" "buttons" ];
    };

    ".config/swaync/style.css".text = ''
      * {
        all: unset;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
      }

      .control-center {
        background: rgba(22, 22, 28, 0.6);
        border-radius: 14px;
      }

      .notification {
        background: rgba(22, 22, 28, 0.6);
        border-radius: 12px;
        padding: 10px;
        margin: 4px;
      }

      .notification-content { background: transparent; }
      .control-center-list { background: transparent; }

      .notification-default-action:hover,
      .notification-action:hover {
        background: rgba(122, 162, 247, 0.15);
      }

      .widget-title { color: #c0caf5; }

      .widget-buttons-grid > button {
        background: rgba(22, 22, 28, 0.6);
        border-radius: 10px;
        color: #c0caf5;
      }
      .widget-buttons-grid > button:hover {
        background: rgba(122, 162, 247, 0.25);
      }

      .control-center-clear-all { color: #c0caf5; }
      .control-center-clear-all:hover { color: #f7768e; }
    '';
  };
}
