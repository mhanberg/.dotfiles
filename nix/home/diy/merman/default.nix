{ pkgs, lib, ... }:
{
  home.packages =
    let
      version = "0.7.0";
      merman = pkgs.rustPlatform.buildRustPackage {
        pname = "merman-cli";
        version = version;

        src = pkgs.fetchFromGitHub {
          owner = "Latias94";
          repo = "merman";
          rev = "v${version}";
          hash = "sha256-PzGHYRUlLjica0OTWcz4BwUJz0ci/FrOabkranOr9gU=";
        };

        # The workspace has no git dependencies, so the vendored lockfile is
        # enough and we avoid having to recompute a cargoHash on every bump.
        cargoLock = {
          lockFile = ./Cargo.lock;
        };

        # merman is a large workspace that also contains wasm/uniffi/ffi crates
        # which don't compile for the host target. Only build the CLI.
        cargoBuildFlags = [
          "-p"
          "merman-cli"
        ];

        # The integration tests render diagrams and expect system fonts and
        # network access, neither of which exist in the build sandbox.
        doCheck = false;

        meta = {
          description = "Headless Rust implementation of Mermaid.js (parse, layout, render to SVG/PNG/JPG/PDF/ASCII)";
          homepage = "https://github.com/Latias94/merman";
          license = with lib.licenses; [
            mit
            asl20
          ];
          mainProgram = "merman-cli";
        };
      };
    in
    [ merman ];
}
