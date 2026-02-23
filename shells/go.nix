# #                   _
#   __ _  ___   _ __ (_)_  __
#  / _` |/ _ \ | '_ \| \ \/ /
# | (_| | (_) || | | | |>  <
#  \__, |\___(_)_| |_|_/_/\_\
#  |___/

{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Core
    go
    gopls

    # Debugging & Linting
    delve
    golangci-lint

    # Formatting & Tools
    gotools # contains goimports
    gofumpt

    # Backend Development
    air # live reload
    sqldef # or go-migrate for DB migrations

    # Database
    mariadb

    # Shell tools
    zsh
    figlet
  ];

  shellHook = ''
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
    figlet -w 200 This is a shell for Go-lang dev!
    exec zsh
  '';
}

