{
  description = "Gleam devshell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    systems = ["x86_64-linux"];
  in
    flake-utils.lib.eachSystem systems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        shell = pkgs.mkShell {
          name = "gleam";
          packages = with pkgs; [
            erlang_nox
            gleam
            rebar3
          ];
        };
      in {
        devShells.default = shell;
      }
    );
}
