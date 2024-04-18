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

        version = "0.0.0";

        nodejs = nodejs-18_x;

        src = fetchFromGitHub {
          owner = "CleverCloud";
          repo = "clever-tools";
          rev = "${version}";
          hash = "sha256-v60evwLnMxU5EGILAvCTtMsO0fWpjfc0TA7upHcrq9U=";
        };

        npmDepsHash = "sha256-AK1CNtFTM3wgel5L2ekmXWHZhIerqKPd5i7X/kJm7No=";

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
