{
  description = "cookidump - dumps cookidoo recipes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
    cookidumpSrc = {
      url = "github:auino/cookidump";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, cookidumpSrc }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pname = "cookidump";

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # cookidumpSrc = pkgs.fetchFromGitHub {
        #   owner = "auino";
        #   repo = "cookidump";
        #   rev = "104f55e7ca30aff97b278432f2a3fc45a8061bf1";
        #   sha256 = "sha256-Gm2ulNrfrB4wZ3SlSVLFK3bTXOtSbhPHN81057wln8o=";
        # };

        cookidumpPy = "${cookidumpSrc}/cookidump.py";

        pyEnv = pkgs.python3.withPackages (pyPkgs: with pyPkgs; [
          selenium
          beautifulsoup4
        ]);

        runtimeInputs = with pkgs; [ pyEnv google-chrome chromedriver ];
        
      in {
        packages.${pname} = pkgs.writeShellApplication {
          inherit runtimeInputs;

          name = pname;

          text = with pkgs; ''
            export GOOGLE_CHROME_PATH=${google-chrome}/bin/google-chrome-stable
            python ${cookidumpPy} ${chromedriver}/bin/chromedriver "$@"
          '';
        };

        packages.default = self.packages.${system}.${pname};

        devShells.default = with pkgs; mkShell {
          GOOGLE_CHROME_PATH="${google-chrome}/bin/google-chrome-stable";
          buildInputs = runtimeInputs;
        };
      }
    );
}
