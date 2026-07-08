{
  pkgs ? import sources.nixpkgs { },
  sources ? import ./npins,
}:
let
  inherit (pkgs)
    mkShell
    npins
    ;
in
{
  shell =
    let
      treefmt = (import sources.treefmt-nixSrc).mkWrapper pkgs (import ./treefmt.nix);
    in
    mkShell {
      buildInputs = [
        npins
        treefmt
      ];
    };
}
