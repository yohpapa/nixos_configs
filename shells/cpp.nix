# #                        _
#   ___ _ __  _ __   _ __ (_)_  __
#  / __| '_ \| '_ \ | '_ \| \ \/ /
# | (__| |_) | |_) || | | | |>  <
#  \___| .__/| .__(_)_| |_|_/_/\_\
#      |_|   |_|

with import <nixpkgs> { };

mkShell {
  buildInputs = [ llvmPackages.clang llvmPackages.lld llvmPackages.llvm zsh ];

  shellHook = ''
    figlet -w 200 This is a shell for C and C++ dev!
    exec zsh
  '';
}
