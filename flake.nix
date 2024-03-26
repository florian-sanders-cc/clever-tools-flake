{
  description = "A flake to build clever-tools";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default-linux";
  };

  outputs = inputs @ { self, nixpkgs, systems, ... }: {
    defaultPackage.x86_64-linux = with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation (finalAttrs: {
        pname = "clever-tools";
        version = "3.4.0";

        src = ./.;

        cleverTools = buildNpmPackage {
          name = finalAttrs.pname;
          src = ./.;
          rev = "be0db0115a1f2cf2899e67517b9fcb7c3e1f6edc";
          npmDepsHash = "sha256-8dbbHJFcgSh0cQkVp1BMwNmf4knCQlqRXbshnKVXQdA=";
          dontNpmBuild = true;
        };

        installPhase = ''
          cp -r ${finalAttrs.cleverTools} $out
        '';

        nativeBuildInputs = [
          nodejs
        ];

        buildInputs = [
          nodejs
        ];

        meta = {
          description = "";
          homepage = "";
          # license = lib.licenses.apache;
          maintainers = with lib.maintainers;
            [ ];
        };
      });
  };

}
