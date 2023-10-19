{
  nixos ? import <nixpkgs/nixos> {}
}:

  let
    logCommitsScript =
      nixos.pkgs.callPackage
        ./.
        {
          revision = nixos.config.system.nixos.revision;
        };
  in
    (
      logCommitsScript
        "show-nixpkgs-updates-on-unstable"
        "nixos-unstable"
    )
