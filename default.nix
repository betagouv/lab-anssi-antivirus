{
  pkgs ? import sources.nixpkgs { },
  sources ? import ./npins,
}:
let
  inherit (pkgs)
    bash_unit
    mkShell
    netcat
    npins
    openssl
    socat
    ;
in
{
  shell =
    let
      treefmt = (import sources.treefmt-nixSrc).mkWrapper pkgs (import ./treefmt.nix);
    in
    mkShell {
      buildInputs = [
        bash_unit
        netcat
        npins
        openssl
        socat
        treefmt
      ];
    };
}
