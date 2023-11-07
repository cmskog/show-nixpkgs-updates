{
  nixos ? import <nixpkgs/nixos> {}
}:

  let
    logCommitsScript =
      nixos.pkgs.callPackage
        ./.
        {
          revision = nixos.config.system.nixos.revision;
          nixpkgs-repository = /The/path/to/your/nixpkgs/repository;
        };
  in
    (
      logCommitsScript
        "show-nixpkgs-updates-on-unstable"
        "nixos-unstable"
    )
