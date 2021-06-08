# install all derivations from this file using:
# nix-env -f environment.nix -i '.*'
let
  pkgs = import <nixpkgs> {};
in rec {
  python = pkgs.python39.withPackages(ps: with ps; [pynvim] );
  vim = pkgs.vim_configurable.override { python3 = python; };
  git = pkgs.git;
  hls = pkgs.haskell-language-server.override { supportedGhcVersions = [ "884" "865" ]; };
  stack = pkgs.stack;
  implicit-hie = pkgs.haskellPackages.implicit-hie;
  pyls = pkgs.python-language-server;
  bls = pkgs.nodePackages.bash-language-server;
  shellcheck = pkgs.shellcheck;
  fzf = pkgs.fzf;
}
