# #_ _                         _
# | | |_   ___ __ ___    _ __ (_)_  __
# | | \ \ / / '_ ` _ \  | '_ \| \ \/ /
# | | |\ V /| | | | | |_| | | | |>  <
# |_|_| \_/ |_| |_| |_(_)_| |_|_/_/\_\

with import <nixpkgs> { };

mkShell {
  buildInputs = [
    llvmPackages.clang-tools
    llvmPackages.clang
    llvmPackages.lld
    llvmPackages.llvm
    cmake
    zsh
  ];

  shellHook = ''
    figlet -w 200 This is a shell for C and C++ dev!
    exec zsh
  '';
}
