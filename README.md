# nix-rust-zig
Getting `cargo-zigbuild` to work with Nix to allow easy Rust cross-compilation.

* `cargo zigbuild --target aarch64-unknown-linux-gnu`
* `nix build .#aarch64`
