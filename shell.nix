{ pkgs, dng_sdk, expat, harfbuzz, freetype, icu, libjpeg-turbo, libpng, libwebp, piex, sfntly, wuffs, zlib, gzip-hpp, skottie_tool }:

with pkgs;
with lib;
mkShell {
  name = "skia-env";

  nativeBuildInputs = [ python2 gn ninja ];

  # buildInputs = [ skottie_tool ];
  buildInputs = [ fontconfig libglvnd mesa xorg.libX11 ]
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit ApplicationServices OpenGL ]);

  shellHook = ''
    rm -rf third_party/externals
    mkdir -p third_party/externals

    ln -s ${dng_sdk} third_party/externals/dng_sdk
    ln -s ${expat} third_party/externals/expat
    ln -s ${freetype} third_party/externals/freetype
    ln -s ${gzip-hpp} third_party/externals/gzip
    ln -s ${harfbuzz} third_party/externals/harfbuzz
    ln -s ${icu} third_party/externals/icu
    ln -s ${libjpeg-turbo} third_party/externals/libjpeg-turbo
    ln -s ${libpng} third_party/externals/libpng
    ln -s ${libwebp} third_party/externals/libwebp
    ln -s ${piex} third_party/externals/piex
    ln -s ${sfntly} third_party/externals/sfntly
    ln -s ${wuffs} third_party/externals/wuffs
    ln -s ${zlib} third_party/externals/zlib
  '';
}
