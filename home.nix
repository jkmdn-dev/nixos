{ pkgs, unstablePkgs, nh, ... }:
{
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

      unstablePkgs.nerdfonts

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
}
