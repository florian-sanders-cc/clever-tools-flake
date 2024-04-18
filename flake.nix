{
  description = "A flake to build clever-tools";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default-linux";
  };

  outputs = inputs @ { self, nixpkgs, systems, ... }: {
    defaultPackage.x86_64-linux = with import nixpkgs { system = "x86_64-linux"; };
      buildNpmPackage rec {
        pname = "clever-tools";

        version = "3.0.0";

        nodejs = nodejs-18_x;

        src = fetchFromGitHub {
          owner = "CleverCloud";
          repo = "clever-tools";
          rev = "${version}";
          hash = "sha256-VoPBMC5qMEAdipTer/8z0YrEe2uN69N5WvkdZ6eSmZQ=";
        };

        npmDepsHash = "sha256-cVLC4q2vy+2X/Kn1082jLa8InipOCirZy6oEBI0fW9o=";

        dontNpmBuild = true;

        postInstall = ''
          mkdir -p $out/share/{bash-completion/completions,zsh/site-functions}
          $out/bin/clever --bash-autocomplete-script $out/bin/clever > $out/share/bash-completion/completions/clever
          $out/bin/clever --zsh-autocomplete-script $out/bin/clever > $out/share/zsh/site-functions/_clever
        '';

        meta = {
          description = "";
          homepage = "";
          # license = lib.licenses.apache;
          maintainers = with lib.maintainers;
            [ ];
        };
      };
  };

}
