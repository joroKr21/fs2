{
  inputs = {
    typelevel-nix.url = "github:typelevel/typelevel-nix";
    nixpkgs.follows = "typelevel-nix/nixpkgs";
    flake-utils.follows = "typelevel-nix/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, typelevel-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ typelevel-nix.overlays.default ];
        };
      in
      {
        devShell = pkgs.devshell.mkShell {
          imports = [ typelevel-nix.typelevelShell ];
          name = "fs2-shell";
          typelevelShell = {
            jdk.package = pkgs.jdk17;
            nodejs.enable = true;
            native.enable = true;
            native.libraries = [ pkgs.zlib pkgs.s2n-tls pkgs.openssl ];
          };
        };
      }
    );
}