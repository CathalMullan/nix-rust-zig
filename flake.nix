{
  description = "Nix Rust Zig";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = github:nmattia/naersk;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig = {
      url = "github:roarkanize/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, naersk, fenix, zig }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (builtins) fromTOML readFile;
        inherit (pkgs) lib mkShell fetchFromGitHub;

        pkgs = import nixpkgs {
          inherit system;
        };

        zig-toolchain = zig.packages.${system}."0.9.1";

        cargoToml = fromTOML (readFile ("${self}/Cargo.toml"));
        rust-toolchain = fenix.packages."${system}".fromToolchainFile {
          file = "${self}/rust-toolchain.toml";
          sha256 = "sha256-4IUZZWXHBBxcwRuQm9ekOwzc0oNqH/9NkI1ejW7KajU=";
        };

        naerskPlatform = naersk.lib.${system}.override {
          cargo = rust-toolchain;
          rustc = rust-toolchain;
        };

        cargo-zigbuild = naerskPlatform.buildPackage {
          name = "cargo-zigbuild";
          version = "0.8.1";

          src = fetchFromGitHub {
            owner = "messense";
            repo = "cargo-zigbuild";
            rev = "v0.8.1";
            sha256 = "sha256-Xd9saaqSc2o8Tl5XSvOb18+t2ru8FGg4LJN3ctVbctI=";
          };
        };

        buildInputs = with pkgs; [
          rust-toolchain
          zig-toolchain
          cargo-zigbuild
        ];
      in
      rec {
        packages = {
          # nix build .#aarch64
          aarch64 = naerskPlatform.buildPackage {
            inherit buildInputs;

            name = "nix-rust-zig";
            version = cargoToml.package.version;
            root = ./.;

            override = _: {
              preBuild = ''
                # exporting HOME to avoid using `/homeless-shelter/Library/Caches`, which will be a read only filesystem
                # on MacOS
                export HOME=$TMP
              '';
            };

            cargoBuild = x: ''cargo $cargo_options zigbuild $cargo_build_options >> $cargo_build_output_json'';
            cargoBuildOptions = x: x ++ [ "--target" "aarch64-unknown-linux-gnu" ];
          };
        };

        # nix develop
        devShell = mkShell {
          inherit buildInputs;
        };
      });
}
