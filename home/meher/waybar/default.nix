{
  ...
}: {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
      layer = "top";
      position = "top";
      height = 36;
      spacing = 4;

      modules-left = [
        "custom/launcher"
        "cpu"
        "memory"
        "temperature"
        "niri/workspaces"
        "idle-inhibitor"
      ];
      modules-center = [ "clock" "mpris" ];
      modules-right = [
        "custom/services"
        "network"
        "pulseaudio"
        "backlight"
        "custom/power"
        "custom/notification"
      ];

      "custom/launcher" = {
        format = "󰊄";
        on-click = "fuzzel";
        tooltip = false;
      };

      cpu = {
        format = "󰻠 {usage}%";
        interval = 2;
        tooltip = false;
      };

      memory = {
        format = "󰍛 {}%";
        interval = 5;
        tooltip = false;
      };

      temperature = {
        format = "󰔏 {temperatureC}°C";
        interval = 10;
        tooltip = false;
      };

      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          default = "●";
          focused = "●";
          urgent = "●";
        };
        tooltip = false;
      };

      "idle-inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "󰅶";
          deactivated = "󰋼";
        };
        tooltip = false;
      };

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%a %d %b}";
        tooltip-format = "{:%A %d %B %Y}";
      };

      mpris = {
        format = "{status_icon}  {artist} - {title}";
        status-icons = {
          playing = "󰐊";
          paused = "󰏤";
          stopped = "󰓛";
        };
        max-length = 40;
      };

      network = {
        format-wifi = "󰖩 {essid}";
        format-ethernet = "󰈀 {ifname}";
        format-disconnected = "󰖪";
        tooltip-format = "{ifname} {ipaddr}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 {volume}%";
        format-icons = {
          headphones = "󰋋";
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        scroll-step = 5;
        tooltip = false;
      };

      backlight = {
        format = "{icon} {percent}%";
        format-icons = [ "󰃞" "󰃟" "󰃝" ];
        on-scroll-up = "brightnessctl -d amdgpu_bl1 set +5%";
        on-scroll-down = "brightnessctl -d amdgpu_bl1 set 5%-";
        tooltip = false;
      };

      "custom/services" = {
        exec = ''
          n=$(systemctl --user list-units --state=running --no-legend 2>/dev/null | wc -l)
          list=$(systemctl --user list-units --state=running --no-legend 2>/dev/null | awk '{print $1}' | paste -sd', ')
          printf '{"text":"󰅟 %s","tooltip":"%s"}\n' "$n" "$list"
        '';
        return-type = "json";
        interval = 60;
        on-click = "kitty --class services -- systemctl --user list-units --state=running";
        tooltip = false;
      };

      "custom/power" = {
        exec = ''
          p=$(powerprofilesctl get)
          case "$p" in
            power-saver) icon="󰾆" ;;
            performance) icon="󰓅" ;;
            *) icon="󰛏" ;;
          esac
          printf '{"text":"%s","tooltip":"power profile: %s","class":"%s"}\n' "$icon" "$p" "$p"
        '';
        on-click = ''
          p=$(powerprofilesctl get)
          case "$p" in
            performance) powerprofilesctl set balanced ;;
            balanced) powerprofilesctl set power-saver ;;
            power-saver) powerprofilesctl set performance ;;
          esac
        '';
        return-type = "json";
        interval = 30;
      };

      "custom/notification" = {
        format = "{icon} {}";
        format-icons = {
          notification = "󰂚";
          none = "󰂛";
          dnd-notification = "󰂛";
          dnd-none = "󰂜";
        };
        exec = "swaync-client -swb";
        exec-if = "pgrep swaync";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        tooltip = false;
      };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      /* floating rounded cards, blurred by the niri layer-rule */
      .modules-left, .modules-center, .modules-right {
        background: rgba(22, 22, 28, 0.6);
        border-radius: 12px;
        padding: 2px 8px;
        margin: 8px 6px;
      }

      tooltip {
        background: rgba(22, 22, 28, 0.85);
        border-radius: 10px;
      }

      #workspaces button {
        padding: 0 6px;
        color: #565f89;
      }
      #workspaces button.active {
        color: #7aa2f7;
      }
      #workspaces button.urgent {
        color: #f7768e;
      }

      #cpu { color: #9ece6a; }
      #memory { color: #e0af68; }
      #temperature { color: #bb9af7; }
      #clock { color: #c0caf5; }
      #mpris { color: #c0caf5; }
      #idle-inhibitor { color: #7dcfff; }
      #network { color: #7aa2f7; }
      #pulseaudio { color: #f7768e; }
      #backlight { color: #e0af68; }
      #custom-power { color: #bb9af7; }
      #custom-services { color: #9ece6a; }
      #custom-launcher { color: #7aa2f7; }
      #custom-notification { color: #c0caf5; }
      #custom-notification.dnd { color: #565f89; }
    '';
  };
}
