{
  description = "MoonBit FreeType development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        llvm = pkgs.llvmPackages;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            gnumake
            pkg-config
            python3
            llvm.clang
            llvm.llvm
            llvm.lld
            llvm.bintools
            llvm.compiler-rt
          ];

          shellHook = ''
            export CC=clang
            export CXX=clang++
            export ASAN_SYMBOLIZER_PATH="$(command -v llvm-symbolizer || true)"

            echo "FreeType LLVM fuzzing environment loaded"
            echo "Run: nix develop"
            echo "Compiler: $(clang --version | head -n1)"
          '';
        };
      }
    );
}
