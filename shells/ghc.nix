# _                  _
#   __ _| |__   ___   _ __ (_)_  __
#  / _` | '_ \ / __| | '_ \| \ \/ /
# | (_| | | | | (__ _| | | | |>  <
#  \__, |_| |_|\___(_)_| |_|_/_/\_\
#  |___/

with import <nixpkgs> { };

mkShell {
  buildInputs = [
    haskellPackages.ghc
    haskellPackages.haskell-language-server
    haskellPackages.ormolu
    haskellPackages.stylish-haskell
    haskellPackages.cabal-install
    zsh
  ];

  shellHook = ''
    figlet -w 200 This is a shell for Haskell dev!
    exec zsh
  '';
}
