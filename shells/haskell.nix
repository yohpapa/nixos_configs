# #_               _        _ _         _
# | |__   __ _ ___| | _____| | |  _ __ (_)_  __
# | '_ \ / _` / __| |/ / _ \ | | | '_ \| \ \/ /
# | | | | (_| \__ \   <  __/ | |_| | | | |>  <
# |_| |_|\__,_|___/_|\_\___|_|_(_)_| |_|_/_/\_\

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
