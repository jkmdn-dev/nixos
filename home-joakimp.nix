{ config, pkgs, nh, nix-search-cli, hyprland, ... }: {

  imports = [ hyprland.homeManagerModules.default ];

  home = {
    username = "joakimp";
    homeDirectory = "/home/joakimp";

    file = {
      ".zshenv" = {
        source = ./.zshenv;
        target = ".zshenv";
      };
      ".config" = {
        source = ./config;
        recursive = true;
      };
    };

    packages = with pkgs;
      [
        # essentials
        zip
        xz
        unzip
        p7zip
        ripgrep
        jq
        fzf
        file
        which
        gnused
        gnutar
        gawk
        gnupg
        gnumake
        btop
        wget
        bat
        eza

        # terminal file manager
        yazi

        # some programs
        chromium
        vivaldi

        # unfree
        teams-for-linux

        #webcam
        libwebcam

        # hyprland essentials
        tofi
        wev # for debugging keybindings
        wireplumber
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-wlr
        hyprpicker
        hypridle
        hyprlock

        #themes
        rose-pine-gtk-theme
        papirus-icon-theme
        bibata-cursors
        catppuccin-gtk

        # fonts
        nerdfonts
        cascadia-code
        babelstone-han

        neovim

        # handle tmux.conf myself, much easier for now
        tmux

        # LSP, FMT, and LINT common for all projects
        codespell

        # shell completion
        carapace

        # dev tools
        gh

        # markdown and docs
        glow
        pandoc
        tectonic

        coreutils
        zig
        universal-ctags
        sqlite
      ] ++ [ nh nix-search-cli ];

    sessionVariables = { GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark"; };

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    stateVersion = "23.11";
  };

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    portal = {
      # enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-wlr
      ];
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [ "black" ];
        variant = "mocha";
      };
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  programs = {
    home-manager = { enable = true; };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
    };

    alacritty = {
      enable = true;
      settings = {
        import = [ "${config.xdg.configHome}/alacritty/rose-pine.toml" ];
        env = { TERM = "xterm-256color"; };
        font = { normal = { family = "Cascadia Code"; }; };
      };
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    git = {
      enable = true;
      # why is this not working?
      userName = "Joakim Paulsson";
      userEmail = "jkmdn@proton.me";
    };

    chromium.enable = true;

  };

  services = {
    ssh-agent = { enable = true; };
    # hypridle = {
    #   enable = true;
    #   settings = {
    #
    #     general = {
    #       "lock_cmd" = "pidof hyprlock || hyprlock";
    #       "before_sleep_cmd" = "loginctl lock-session";
    #       "after_sleep_cmd" = "hyprctl dispatch dpms on";
    #     };
    #
    #     listener = [
    #       {
    #         "timeout" = "150";
    #         "on-timeout" = "brightnessctl -s set 10";
    #         "on-resume" = "brightnessctl -r";
    #       }
    #       # {
    #       #   "timeout" = "150";
    #       #   "on-timeout" = "brightnessctl -sd rgb:kbd_backlight set 0";
    #       #   "resume" = "brightnessctl -rd rgb:kbd_backlight";
    #       # }
    #       {
    #         "timeout" = "300";
    #         "on-timeout" = "loginctl lock-session";
    #       }
    #       {
    #         "timeout" = "330";
    #         "on-timeout" = "hyprctl dispatch dpms off";
    #         "on-resume" = "hyprctl dispatch dpms on";
    #       }
    #
    #       {
    #         "timeout" = "1800";
    #         "on-timeout" = "systemctl suspend";
    #       }
    #     ];
    #   };
    # };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "monitor" = [
        "DP-5,3840x2160@60,0x0,2,transform,3"
        "DP-4,3440x1440@60,1080x480,1"
        "eDP-1,1920x1080@60,4520x1440,1"
      ];
      "$mod" = "SUPER";

      "$lock" = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hypridle"
      ];
      exec = [ "alacritty" "vivaldi" ];

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

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

      bind = [
        "$mod, d, exec, tofi-drun | xargs hyprctl dispatch exec --"
        "$mod, t, exec, alacritty"
        "$mod, v, exec, vivaldi"
        "$mod, q, killactive,"

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "SUPER+CONTROL, j, workspace, +1"
        "SUPER+CONTROL, k, workspace, -1"

        "SUPER+SHIFT, j, movetoworkspace, +1"
        "SUPER+SHIFT, k, movetoworkspace, -1"

        # Special Keys
        ", xf86monbrightnessup, exec, brightnessctl set 10%+"
        ", xf86monbrightnessdown, exec, brightnessctl set 10%-"
        ", xf86audioraisevolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+"
        ", xf86audiolowervolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%-"
        ", xf86audiomute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"

        "SUPER,Tab,cyclenext,"
        "SUPER,Tab,bringactivetotop,"

        "SUPER?SHIFT+CONTROL, l, exec, loginctl lock-session"
      ];

      input = {
        "kb_layout" = "us,se";
        "kb_variant" = "";
        "kb_model" = "";
        "kb_options" = "ctrl:nocaps,grp:win_space_toggle";
      };

      general = {
        "gaps_in" = "1";
        "gaps_out" = "1";
        "border_size" = "2";
        "col.active_border" = "$subtle";
        "col.inactive_border" = "$muted";
      };

      animations = { "enabled" = "no"; };

      misc = {
        "disable_hyprland_logo" = "true";
        "disable_splash_rendering" = "true";
        "force_default_wallpaper" = "0";
        "disable_autoreload" = "true";
        "key_press_enables_dpms" = "true";
        "mouse_move_enables_dpms" = "true";
      };

      # listener = {
      #     "timeout" = [ 
      #       "150" 
      #       "300"
      #       "330"
      #       "1800"
      #     ];
      #     "on-timeout" = [ 
      #       "brightnessctl -s set 10"
      #       "loginctl lock-session"
      #       "hyprctl dispatch dpms off"
      #       "systemctl suspend"
      #     ];
      #     "on-resume" = [ 
      #       "brightnessctl -r"
      #       ""
      #       "hyprctl dispatch dpms on"
      #       ""
      #     ];
      # };
    };
  };
}
