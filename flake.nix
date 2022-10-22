{
	description = "Nix developement flake for our blockchain project";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = import nixpkgs { inherit system; }; 
				ghc = pkgs.haskellPackages.ghcWithPackages (p: [
					p.curl
					p.megaparsec
					p.replace-megaparsec
				]);
			in {
				devShell = pkgs.mkShell {
					buildInputs = with pkgs; [
						ghc
					];
				};
			}
		);
}
