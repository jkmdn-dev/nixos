{ pkgs, nh, hyprland, ... }:
{
  
  imports = [
    hyprland.homeManagerModules.default
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = "joakimp";
    homeDirectory = "/home/joakimp";

    packages = with pkgs; [
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
      tree
      gnused
      gnutar
      gawk
      gnupg
      btop
      wget
      bat

      # hyprland essentials
      mako
      swayidle
      swaylock
      tofi
      wev # for debugging keybindings

      rose-pine-gtk-theme
      papirus-icon-theme
      bibata-cursors
      catppuccin-gtk

      # dashboard
      wtf

      nerdfonts

      # this is not setup correctly
      nh

      neovim
      # nasty hack to get Copilot working
      # find a way to get rid of this
      (python3.withPackages (python-pkgs: [
        python-pkgs.python-dotenv
        python-pkgs.requests
        python-pkgs.pynvim
        python-pkgs.prompt-toolkit
        python-pkgs.tiktoken
      ]))
      nodejs_21

      #get rid of this in future
      zig
      clang
      rustup
      cmake
      pkg-config

      # dev
      direnv
    ];

    stateVersion = "23.11";
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
        accents = ["mauve"];
        size = "standard";
        tweaks = ["black"];
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

  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark";
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.package = pkgs.bibata-cursors;
  home.pointerCursor.name = "Bibata-Modern-Ice";

  programs = {
    home-manager = {
      enable = true;
    };

    tmux = {
      enable = true;
      extraConfig =
        ''
          set-option -g default-shell $SHELL
          set -g default-terminal "tmux-256color"
          set -ag terminal-overrides ",xterm-256color:RGB"

          # Hide status bar
          set-option -g status off
          bind-key q set-option status

          # Movement and resize vim controls
          bind -r C-k resize-pane -U
          bind -r C-j resize-pane -D
          bind -r C-h resize-pane -L
          bind -r C-l resize-pane -R

          bind -r k select-pane -U
          bind -r j select-pane -D
          bind -r h select-pane -L
          bind -r l select-pane -R
        '';
    };


    git = {
      enable = true;
      # why is this not working?
      userName = "Joakim Paulsson";
      userEmail = "joakim.jp.paulsson@gmail.com";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true; 

    settings = {
      "monitor" = "eDP-1,1920x1080@60,auto,1";
      "$mod" = "SUPER";

      "$lock" = "swaylock -f --color 1e1e2eFF";
      exec-once = [
        "alacritty"
        #"swayidle -w timeout 300 '$lock' timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep '$lock'"
        #"mako"
        #"tofi"
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
        "$mod, d, exec, tofi-drun | xargs hyprctl dispatch exec --"

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
      ];

      input = {
        "kb_layout" = "se";
        "kb_variant" = "";
        "kb_model" = "pc104";
        "kb_options" = "ctrl:nocaps";
      };

      general = {
        "gaps_in" = "1";
        "gaps_out" = "1";
        "border_size" = "2";
        "col.active_border" = "$subtle";
        "col.inactive_border" = "$muted";
      }; 

      animations = {
        "enabled" = "no";
      };

      misc = {
        "disable_hyprland_logo" = "true";
        "disable_splash_rendering" = "true";
        "force_default_wallpaper" = "0";
        "disable_autoreload" = "true";

       # "key_press_enables_dpms" = "true";
       # "mouse_move_enables_dpms" = "true";
      };

    };
  };
}
