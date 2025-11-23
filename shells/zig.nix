# #    _               _
#  ___(_) __ _   _ __ (_)_  __
# |_  / |/ _` | | '_ \| \ \/ /
#  / /| | (_| |_| | | | |>  <
# /___|_|\__, (_)_| |_|_/_/\_\
#        |___/

with import <nixpkgs> { };

mkShell {
  buildInputs = [ zig zls zig-shell-completions figlet zsh ];

  shellHook = ''
    figlet -w 200 This is a shell for Zig dev!
    export FPATH="${zig-shell-completions}/share/zsh/site-functions:$FPATH"
    exec zsh
  '';
}
