{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    nixelixir.url = "/home/maxim/projects/nix-elixir";

  };

  outputs = { self, nixpkgs, utils, nixelixir }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ nixelixir.overlay ];
        };
      in with pkgs;
      let

        basePackages = [
          beam.packages.erlangR25.elixir_1_14
          cudaPackages_11_8.cudatoolkit
          cudaPackages_11_8.libcublas

          livebook

        ];

        libPath = lib.makeLibraryPath [
          cudaPackages_11_8.cudatoolkit
          cudaPackages_11_8.libcublas
        ];

      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = basePackages;
            LD_LIBRARY_PATH = "${libPath}:/run/opengl-driver/lib";
            shellHook = "export CUDA_DIR=${cudaPackages_11_8.cudatoolkit}";

          };

      });
}
