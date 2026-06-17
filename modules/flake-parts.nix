{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    ./features/audio
    ./features/desktop
    ./features/packages
    ./features/system
    ./profiles
  ];

  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
    description = "Home Manager modules exported by this flake.";
  };

  config.systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
