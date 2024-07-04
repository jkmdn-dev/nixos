{ config, pkgs, ... }: {


  home = {
    username = "joakimp";
    homeDirectory = "/home/joakimp";

    file = {
      ".config" = {
        source = ./config;
        recursive = true;
      };
    };

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

      # dashboard
      wtf

      nerdfonts
      cascadia-code
      babelstone-han

      neovim

      tmux # handle tmux.conf myself, much easier for now

      # LSP, FMT, and LINT
      fnlfmt
      fennel-ls
      nixfmt
      nil
      codespell

      # shell completion
      carapace

      # markdown
      glow

      pandoc
      tectonic

      coreutils
      zig
      universal-ctags
      sqlite
    ];

    stateVersion = "23.11";
  };

  fonts.fontconfig.enable = true;

  xdg = { enable = true; };

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
      userEmail = "joakim.jp.paulsson@gmail.com";
    };

  };

  services = {
    ssh-agent = { enable = true; };
  };

}
