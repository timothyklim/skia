{
  description = "Skia flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";

    # Build deps
    icu = {
      url = "git+https://chromium.googlesource.com/chromium/deps/icu.git?rev=a0718d4f121727e30b8d52c7a189ebf5ab52421f";
      flake = false;
    };
    zlib = {
      url = "git+https://chromium.googlesource.com/chromium/src/third_party/zlib?rev=c876c8f87101c5a75f6014b0f832499afeb65b73";
      flake = false;
    };
    expat = {
      url = "github:libexpat/libexpat/441f98d02deafd9b090aea568282b28f66a50e36";
      flake = false;
    };
    libjpeg-turbo = {
      url = "git+https://chromium.googlesource.com/chromium/deps/libjpeg_turbo.git?rev=ed683925e4897a84b3bffc5c1414c85b97a129a3&ref=main";
      flake = false;
    };
    sfntly = {
      url = "github:googlei18n/sfntly/b55ff303ea2f9e26702b514cf6a3196a2e3e2974";
      flake = false;
    };
    dng_sdk = {
      url = "git+https://android.googlesource.com/platform/external/dng_sdk.git?rev=c8d0c9b1d16bfda56f15165d39e0ffa360a11123";
      flake = false;
    };
    piex = {
      url = "git+https://android.googlesource.com/platform/external/piex.git?rev=bb217acdca1cc0c16b704669dd6f91a1b509c406";
      flake = false;
    };
    libwebp = {
      url = "git+https://chromium.googlesource.com/webm/libwebp.git?rev=2af26267cdfcb63a88e5c74a85927a12d6ca1d76&ref=1.3.1";
      flake = false;
    };
    harfbuzz = {
      url = "github:harfbuzz/harfbuzz/4cfc6d8e173e800df086d7be078da2e8c5cfca19";
      flake = false;
    };
    freetype = {
      url = "git+https://chromium.googlesource.com/chromium/src/third_party/freetype2.git?rev=45903920b984540bb629bc89f4c010159c23a89a";
      flake = false;
    };
    libpng = {
      url = "git+https://skia.googlesource.com/third_party/libpng.git?rev=386707c6d19b974ca2e3db7f5c61873813c6fe44";
      flake = false;
    };
    wuffs = {
      url = "git+https://skia.googlesource.com/external/github.com/google/wuffs-mirror-release-c.git?rev=e3f919ccfe3ef542cfc983a82146070258fb57f8&ref=main";
      flake = false;
    };
    gzip-hpp = {
      url = "github:mapbox/gzip-hpp";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, dng_sdk, expat, harfbuzz, freetype, icu, libjpeg-turbo, libpng, libwebp, piex, sfntly, wuffs, zlib, gzip-hpp }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      skottie_tool = import ./build.nix {
        inherit pkgs dng_sdk expat harfbuzz freetype icu libjpeg-turbo libpng libwebp piex sfntly wuffs zlib gzip-hpp;
      };
      derivation = { inherit skottie_tool; };
    in
    rec {
      packages.${system} = derivation // { default = skottie_tool; };
      legacyPackages.${system} = pkgs.extend overlays.default;
      devShells.${system}.default = pkgs.callPackage ./shell.nix {
        inherit pkgs dng_sdk expat harfbuzz freetype icu libjpeg-turbo libpng libwebp piex sfntly wuffs zlib gzip-hpp skottie_tool;
      };
      nixosModules.default = {
        nixpkgs.overlays = [ overlays.default ];
      };
      overlays.default = final: prev: derivation;
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    };
}
