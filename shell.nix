{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "gleam";
  nativeBuildInputs = with pkgs.buildPackages; [
    gleam
    erlang_nox
    rebar3
  ];
}
