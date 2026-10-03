{
  description = "Sysadmin DeCal website configuration for the Open Computing Facility";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    systems.url = "github:nix-systems/default";
  };
  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:
    let
      pkgsFor = system: import nixpkgs { inherit system; };
      forAllSystems = fn: nixpkgs.lib.genAttrs (import systems) (system: fn (pkgsFor system));
    in
    {
      packages = forAllSystems (pkgs: rec {
        default = pkgs.callPackage ./. { };
        image = pkgs.dockerTools.streamLayeredImage (
          let
            timestamp = builtins.readFile (
              pkgs.runCommand "timestamp" { } ''
                date --date='@${toString self.lastModified}' --iso-8601=minutes > $out
              ''
            );

            decalwebPath = default;

            nginxPort = "80";
            nginxConf = pkgs.writeText "nginx.conf" ''
              user nobody nobody;
              daemon off;
              error_log /dev/stdout info;
              pid /dev/null;
              events {}
              http {
                include ${pkgs.nginx}/conf/mime.types;
                default_type application/octet-stream;
                access_log /dev/stdout;
                server {
                  listen ${nginxPort};
                  root ${decalwebPath};
                }
              }
            '';
          in
          {
            name = "decalweb";
            created = timestamp;
            mtime = timestamp;

            contents = with pkgs; [
              busybox
              nginx
              dockerTools.fakeNss
            ];

            extraCommands = ''
              # nginx requires these dirs to exist, see:
              # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/docker/examples.nix
              mkdir -p tmp/nginx_client_body
              mkdir -p var/log/nginx
            '';

            config = {
              Cmd = [
                "nginx"
                "-c"
                nginxConf
              ];
              ExposedPorts = {
                "${nginxPort}/tcp" = { };
              };
            };
          }
        );
      });
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          inputsFrom = [ self.packages.${pkgs.system}.default ];
          shellHook = "hugo server --minify";
        };
        deploy = pkgs.mkShell {
          packages = with pkgs; [
            rsync
            openssh
          ];
        };
      });
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}
