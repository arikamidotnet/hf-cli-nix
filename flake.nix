{
  description = "Hugging Face CLI (hf) packaged as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          });
    in
    {
      packages = forEachSystem ({ pkgs, system }: {
        default = self.packages.${system}.hf;

        hf = pkgs.python3Packages.huggingface-hub.overridePythonAttrs (old: {
          meta = (old.meta or { }) // {
            description = "Hugging Face CLI (hf) packaged as a standalone Nix flake";
            homepage = "https://github.com/arikamidotnet/hf-cli-nix";
            license = pkgs.lib.licenses.asl20;
            maintainers = [ ];
            mainProgram = "hf";
          };
        });
      });

      apps = forEachSystem ({ system, ... }: {
        default = {
          type = "app";
          program = "${self.packages.${system}.hf}/bin/hf";
        };
      });

      devShells = forEachSystem ({ pkgs, system }: {
        default = pkgs.mkShell {
          packages = [ self.packages.${system}.hf ];
        };
      });
    };
}
