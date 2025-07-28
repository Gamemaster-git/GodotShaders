{
  description = "Godot shader development enviroment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    system = "x86_64-linux";
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        gdtoolkit_4
        self.packages.${pkgs.system}.gdshader-lsp
      ];

      shellHook = ''
        ${pkgs.onefetch}/bin/onefetch
        zsh
      '';
    };

    packages.${system} = rec {
      gdshader-lsp = pkgs.stdenv.mkDerivation {
        pname = "gdshader-lsp";
        version = "v0.1";

        src = pkgs.fetchurl {
          url = "https://github.com/GodOfAvacyn/gdshader-lsp/releases/download/v0.1/gdshader-lsp";
          sha256 = "0s240i2zfjcgs5zga0ychrhjgv7dwnfz6yvknpw296k3i2ysq5ja";
        };

        phases = ["installPhase"];

        installPhase = ''
          mkdir -p $out/bin
          cp $src $out/bin/gdshader-lsp
          chmod +x $out/bin/gdshader-lsp
        '';
      };

      default = self.packages.${system}.gdshader-lsp;
    };
  };
}
