{
  description = "A flake to build clever-tools";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.buildNpmPackage rec {
          pname = "clever-tools";

          version = "3.6.0";

          nodejs = pkgs.nodejs-18_x;

          src = pkgs.fetchFromGitHub {
            owner = "CleverCloud";
            repo = "clever-tools";
            rev = "${version}";
            hash = "sha256-3LZ04YeVrKXa9rk3Wh4yS4zk4cUyT0fw7VnsaPXdKgs=";
          };

          npmDepsHash = "sha256-dJpe+YgklzuwBF1FnTQxBCiIBF2gaG9MIp0cfRl+YfQ=";

          dontNpmBuild = true;

          postInstall = ''
            mkdir -p $out/share/{bash-completion/completions,zsh/site-functions}
            $out/bin/clever --bash-autocomplete-script $out/bin/clever > $out/share/bash-completion/completions/clever
            $out/bin/clever --zsh-autocomplete-script $out/bin/clever > $out/share/zsh/site-functions/_clever
          '';

          meta = {
            description = "";
            homepage = "";
            maintainers = with pkgs.lib.maintainers;
              [ ];
          };
        };
      });
    };
}
