---
sidebar_position: 1
title: Flake input
sidebar_label: Flake input
slug: /installation/nixos
---

# NixOS: Flake input

Wayshell provides flake outputs, a NixOS module for system dependencies, and a Home Manager module for user configuration and service management. This page covers the flake and the system module; see [Home Manager](/installation/nixos/home-manager) for the user configuration.

## Add the flake input

Add Wayshell to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wayshell.url = "github:mora1ss/wayshell";
  };

  outputs = { self, nixpkgs, wayshell, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit wayshell; };
      modules = [
        ./configuration.nix
        wayshell.nixosModules.default
      ];
    };
  };
}
```

## Enable the system module

Enable the NixOS module to configure system prerequisites:

```nix
{
  programs.wayshell.enable = true;
}
```

If you prefer installing the package directly without the system module:

```nix
{ pkgs, wayshell, ... }:

{
  environment.systemPackages = [
    wayshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    wayshell.packages.${pkgs.stdenv.hostPlatform.system}.ski
  ];
}
```

This installs Ski without the system module. Setting it as the default file manager and the open / save dialog needs the system module.

## Updating

Update the flake lockfile and rebuild your system:

```bash
nix flake update wayshell
sudo nixos-rebuild switch --flake .
```
