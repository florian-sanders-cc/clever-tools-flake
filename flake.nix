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

          version = "3.4.0";

          nodejs = pkgs.nodejs-18_x;

          src = pkgs.fetchFromGitHub {
            owner = "CleverCloud";
            repo = "clever-tools";
            rev = "${version}";
            hash = "sha256-3su+QU7TsgOghV35pqgLqzGlJNbSQ54IC2XxRh8RGkc=";
          };

          npmDepsHash = "sha256-QZ1t0tA15ztQWnaYiajt4JdzzvqNxn1IjaVP/D9WyQk=";

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
