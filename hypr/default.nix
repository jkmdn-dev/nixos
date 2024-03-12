{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true; 

    settings = {
      "monitor" = "eDP-1,1920x1080@60,auto,1";
      "$mod" = "SUPER";

      "$lock" = "swaylock -f --color 1e1e2eFF";
      exec-once = [
        "alacritty"
        "swayidle -w timeout 300 '$lock' timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep '$lock'"
        "mako"
        "tofi"
      ];

      ## name: Rosé Pine
      ## author: jishnurajendran
      ## upstream: https://github.com/jishnurajendran/hyprland-rosepine/blob/main/rose-pine.conf
      ## All natural pine, faux fur and a bit of soho vibes for the classy minimalist
      "$base" = "0xff191724";
      "$surface" = "0xff1f1d2e";
      "$overlay" = "0xff26233a";
      "$muted" = "0xff6e6a86";
      "$subtle" = "0xff908caa";
      "$text" = "0xffe0def4";
      "$love" = "0xffeb6f92";
      "$gold" = "0xfff6c177";
      "$rose" = "0xffebbcba";
      "$pine" = "0xff31748f";
      "$foam" = "0xff9ccfd8";
      "$iris" = "0xffc4a7e7";
      "$highlightLow" = "0xff21202e";
      "$highlightMed" = "0xff403d52";
      "$highlightHigh" = "0xff524f67";

      bind = [
        "$mod, D, exec, tofi-drun | xargs hyprctl dispatch exec --"

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod CTRL, j, workspace, e+1"
        "$mod CTRL, k, workspace, e-1"

        "$mod SHIFT, j, movetoworkspace, e+1"
        "$mod SHIFT, k, movetoworkspace, e-1"

        # Special Keys
        ", xf86monbrightnessup, exec, brightnessctl set 10%+"
        ", xf86monbrightnessdown, exec, brightnessctl set 10%-"
        ", xf86audioraisevolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+"
        ", xf86audiolowervolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%-"
        ", xf86audiomute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"

        "SUPER,Tab,cyclenext,"
        "SUPER,Tab,bringactivetotop,"
      ];

      input = {
        "kb_layout" = "se";
        "kb_variant" = "";
        "kb_model" = "pc104";
        "kb_options" = "ctrl:nocaps";
        "follow_mouse" = "1";
      };

      general = {
        "gaps_in" = "1";
        "gaps_out" = "1";
        "border_size" = "2";
        "col.active_border" = "$rose";
        "col.inactive_border" = "$muted";
      }; 

      animations = {
        "enabled" = "no";
      };

      misc = {
        "disable_hyprland_logo" = "true";
        "disable_splash_rendering" = "true";
        "force_default_wallpaper" = "0";
        "variable_framerate" = "true";
        "disable_autoreload" = "true";

        "key_press_enables_dpms" = "true";
        "mouse_move_enables_dpms" = "true";
      };

    };
  };
}
