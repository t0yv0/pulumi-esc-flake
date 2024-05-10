{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs?rev=b7cde1c47b7316f6138a2b36ef6627f3d16d645c;
    pulumi_darwin_x64.url = "https://github.com/pulumi/esc/releases/download/v0.8.3/esc-v0.8.3-darwin-x64.tar.gz";
    pulumi_darwin_x64.flake = false;
    pulumi_darwin_arm64.url = "https://github.com/pulumi/esc/releases/download/v0.8.3/esc-v0.8.3-darwin-arm64.tar.gz";
    pulumi_darwin_arm64.flake = false;
    pulumi_linux_x64.url = "https://github.com/pulumi/esc/releases/download/v0.8.3/esc-v0.8.3-linux-x64.tar.gz";
    pulumi_linux_x64.flake = false;
    pulumi_linux_arm64.url = "https://github.com/pulumi/esc/releases/download/v0.8.3/esc-v0.8.3-linux-arm64.tar.gz";
    pulumi_linux_arm64.flake = false;
  };

  outputs =
    { self,
      nixpkgs,
      pulumi_darwin_x64,
      pulumi_darwin_arm64,
      pulumi_linux_x64,
      pulumi_linux_arm64,
    }:

    let

      packagePulumi = sys:
        let
          version = "v0.8.3";
          pulumiSources = {
            "x86_64-darwin" = pulumi_darwin_x64;
            "aarch64-darwin" = pulumi_darwin_arm64;
            "x86_64-linux" = pulumi_linux_x64;
            "aarch64-linux" = pulumi_linux_arm64;
          };
          pulumi_src = builtins.getAttr sys pulumiSources;
          pkgs = import nixpkgs { system = sys; };
        in
          pkgs.stdenv.mkDerivation {
            name = "pulumi-esc-${version}";
            version = "${version}";
            src = pulumi_src;
            installPhase = "mkdir -p $out/bin && cp $src/esc* $out/bin/";
          };

      packages = sys:
        let
          pkgs = import nixpkgs { system = sys; };
        in {
          default = packagePulumi sys;
        };

    in {
      packages.x86_64-linux = packages "x86_64-linux";
      packages.x86_64-darwin = packages "x86_64-darwin";
      packages.aarch64-darwin = packages "aarch64-darwin";
      packages.aarch64-linux = packages "aarch64-linux";
    };
}
