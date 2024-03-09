{pkgs, nh, ... }:
{
  home.username = "joakimp";
  home.homeDirectory = "/home/joakimp";

  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip
    ripgrep
    jq
    lsd
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
    nh

    neovim
    (python3.withPackages (python-pkgs: [
      python-pkgs.python-dotenv
      python-pkgs.requests
      python-pkgs.pynvim
      python-pkgs.prompt-toolkit
      python-pkgs.tiktoken
    ]))
    nodejs_21

    zig
    clang
    rustup
    cmake
    pkg-config
    direnv

    nix-search-cli
  ];

  home.stateVersion = "23.11";

  programs = {
    home-manager = {
      enable = true;
    };
    
    git = {
      enable = true;
      userName = "Joakim Paulsson";
      userEmail = "joakim.jp.paulsson@gmail.com";
    };

    zsh = {
      enable = true;
    };

  };
}
