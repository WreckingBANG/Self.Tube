{
  description = "Self.Tube Dev-Shell";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };
        buildToolsVersion = "36.0.0";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ buildToolsVersion "35.0.0" ];
          platformVersions = [ 31 34 35 36 37 ];
          abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
          ndkVersions = [ "28.2.13676358" ];
          cmakeVersions = [ "3.22.1" ];
          includeNDK = true;
        };
        androidSdk = androidComposition.androidsdk;
      in
      {
        devShell =
          with pkgs; mkShell {
            
            ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
            nativeBuildInputs = [ pkg-config ];
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
            
            buildInputs = [
              androidSdk
              flutter
              jdk17
              libsecret
              fontconfig
              glibcLocales
              gtk3
              glib
              libxi
              ffmpeg
              mpv
              openjdk17
              flutter
              alsa-lib
              pkg-config
              sysprof
              sysprof.dev
              libepoxy
              libass
              libxdmcp
              libx11
              libxext
              libxrender
              libxrandr
              wayland
              libxkbcommon
              libva
              libplacebo
              libunwind
              shaderc
              vulkan-loader
              lcms2
              libdovi
            ];

            shellHook = ''
              export LANG=en_US.UTF-8
              export LC_ALL=en_US.UTF-8
              
              export FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf
              
              export JAVA_HOME="${pkgs.openjdk17}"
              export ANDROID_NDK_ROOT="${androidSdk}/libexec/android-sdk/ndk/28.2.12403333"

              export CMAKE_PREFIX_PATH="${pkgs.alsa-lib}:${pkgs.alsa-lib.dev}:$CMAKE_PREFIX_PATH"
              export CMAKE_INCLUDE_PATH="${pkgs.alsa-lib.dev}/include:$CMAKE_INCLUDE_PATH"
              export CMAKE_LIBRARY_PATH="${pkgs.alsa-lib}/lib:$CMAKE_LIBRARY_PATH"
              export CMAKE_ARGS="-DALSA_LIBRARY=${pkgs.alsa-lib}/lib/libasound.so -DALSA_INCLUDE_DIR=${pkgs.alsa-lib.dev}/include -DCA_BUNDLE=/etc/ssl/certs/ca-bundle.crt"

              export LD_LIBRARY_PATH="${pkgs.sqlite.out}/lib:${pkgs.lib.makeLibraryPath [ gtk3 glib libsecret libepoxy alsa-lib ]}:$LD_LIBRARY_PATH"
              
              export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
              export CURL_CA_BUNDLE="/etc/ssl/certs/ca-bundle.crt"
              
              export ALSA_LIBRARY="${pkgs.alsa-lib}/lib/libasound.so"
              export ALSA_INCLUDE_DIR="${pkgs.alsa-lib.dev}/include"
               
              export PKG_CONFIG_PATH="${pkgs.vulkan-loader}/lib/pkgconfig:${pkgs.alsa-lib}/lib/pkgconfig:${pkgs.sysprof.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
              
              echo "The Self.Tube Dev-Shell is ready!"
            '';

          };
      }
   );
}
