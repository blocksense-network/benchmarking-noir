{
  description = "A non-trivial ZKP";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { system = system; };

    py-pkgs = pythonPackages: with pythonPackages; [
      networkx
      scipy
    ];
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        (python3.withPackages py-pkgs)
        gnumake
      ];
    };
  };
}
