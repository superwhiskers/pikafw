{ sources ? import ./nix/sources.nix, pkgs ? import ./nix { inherit sources; }
}:

pkgs.mkShell {
  name = "pikafw-shell";

  buildInputs = with pkgs; [
    pikafw-binutils
    niv
    python3
    python37Packages.cryptography
    (latest.rustChannels.nightly.rust.override { extensions = [ "rust-src" ]; })
  ];
}
