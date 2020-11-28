{ sources ? import ./sources.nix }:

let
  mozilla-overlay = import sources.mozilla-overlay.outPath;
  pikafw-overlay = self: super: {
    pikafw-binutils = super.binutils-unwrapped.overrideAttrs (oldAttrs: {
      configureFlags = oldAttrs.configureFlags ++ [ "--target=arm-none-eabi" ];
      doInstallCheck = false;
    });
  };
in import sources.nixpkgs { overlays = [ mozilla-overlay pikafw-overlay ]; }
