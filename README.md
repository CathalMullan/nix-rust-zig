# nix-rust-zig
Attempting to get `cargo-zigbuild` to work with Nix to allow easy Rust cross-compilation.

```
❯ cargo zigbuild --target aarch64-unknown-linux-gnu
   Compiling nix-rust-zig v0.1.0 (~/workspace/nix-rust-zig)
    Finished dev [unoptimized + debuginfo] target(s) in 1.25s
```

```
❯ nix build .#aarch64
error: builder for '/nix/store/ji4967rrzvr21735irnhyc9l0dl8w5dw-nix-rust-zig-deps-0.1.0.drv' failed with exit code 1;
       last 10 log lines:
       > [naersk] RUSTFLAGS:
       > [naersk] CARGO_BUILD_RUSTFLAGS:
       > [naersk] CARGO_BUILD_RUSTFLAGS (updated): --remap-path-prefix /nix/store/d22kgl4kday0x3if5czv9ga33xhkb5vi-crates-io=/sources
       > building
       > cargo zigbuild $cargo_release -j "$NIX_BUILD_CORES" --message-format=$cargo_message_format --target aarch64-unknown-linux-gnu
       > Error: failed to create directory `/homeless-shelter/Library/Caches/cargo-zigbuild/0.8.1`
       >
       > Caused by:
       >     Read-only file system (os error 30)
       > [naersk] cargo returned with exit code 1, exiting
       For full logs, run 'nix log /nix/store/ji4967rrzvr21735irnhyc9l0dl8w5dw-nix-rust-zig-deps-0.1.0.drv'.
error: 1 dependencies of derivation '/nix/store/s15qyq5jx7nh4ycwz6vbi4lw6p1hswkf-nix-rust-zig-0.1.0.drv' failed to build
```

```
❯ nix log /nix/store/ji4967rrzvr21735irnhyc9l0dl8w5dw-nix-rust-zig-deps-0.1.0.drv
@nix { "action": "setPhase", "phase": "unpackPhase" }
unpacking sources
unpacking source archive /nix/store/vb7jnanr4flznzskyif217b4sf63hi1a-dummy-src
source root is dummy-src
@nix { "action": "setPhase", "phase": "patchPhase" }
patching sources
@nix { "action": "setPhase", "phase": "updateAutotoolsGnuConfigScriptsPhase" }
updateAutotoolsGnuConfigScriptsPhase
@nix { "action": "setPhase", "phase": "configurePhase" }
configuring
[naersk] cargo_version (read): 1.59.0 (49d8809dc 2022-02-10)
[naersk] cargo_message_format (set): json-diagnostic-rendered-ansi
[naersk] cargo_release: --release
[naersk] cargo_options:
[naersk] cargo_build_options: $cargo_release -j "$NIX_BUILD_CORES" --message-format=$cargo_message_format --target aarch64-unknown-linux-gnu
[naersk] cargo_test_options: $cargo_release -j "$NIX_BUILD_CORES"
[naersk] RUST_TEST_THREADS: 10
[naersk] cargo_bins_jq_filter: .
[naersk] cargo_build_output_json (created): /private/tmp/nix-build-nix-rust-zig-deps-0.1.0.drv-0/tmp.GkGLm63OCp
[naersk] crate_sources: /nix/store/d22kgl4kday0x3if5czv9ga33xhkb5vi-crates-io
[naersk] RUSTFLAGS:
[naersk] CARGO_BUILD_RUSTFLAGS:
[naersk] CARGO_BUILD_RUSTFLAGS (updated): --remap-path-prefix /nix/store/d22kgl4kday0x3if5czv9ga33xhkb5vi-crates-io=/sources
@nix { "action": "setPhase", "phase": "buildPhase" }
building
cargo zigbuild $cargo_release -j "$NIX_BUILD_CORES" --message-format=$cargo_message_format --target aarch64-unknown-linux-gnu
Error: failed to create directory `/homeless-shelter/Library/Caches/cargo-zigbuild/0.8.1`

Caused by:
    Read-only file system (os error 30)
[naersk] cargo returned with exit code 1, exiting
```
