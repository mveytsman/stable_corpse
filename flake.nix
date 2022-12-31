{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
    nixelixir.url = "github:mveytsman/nix-elixir";

  };

  outputs = { self, nixpkgs, utils, nixelixir, nixgl }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ nixelixir.overlay nixgl.overlay ];
        };
      in with pkgs;
      let

        basePackages = [
          beam.packages.erlangR25.elixir_1_14
          cudaPackages_11_8.cudatoolkit
          cudaPackages_11_8.libcublas
cudaPackages_11_8.cudnn
          livebook
        pkgs.nixgl.auto.nixGLNvidia
];

        libPath = lib.makeLibraryPath [
          cudaPackages_11_8.cudatoolkit
          cudaPackages_11_8.libcublas
	cudaPackages_11_8.cudnn
        ];

      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = basePackages;
 LD_LIBRARY_PATH = "${libPath}";
            shellHook = ''
		export CUDA_DIR=${cudaPackages_11_8.cudatoolkit}
		export XLA_FLAGS="--xla_gpu_cuda_data_dir=${cudaPackages_11_8.cudatoolkit}"
	'';

          };

      });
}
