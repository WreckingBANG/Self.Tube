{
  description = "Ephemeral Android dev shell with Android Studio and SDK";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, android-nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        android-nix = pkgs.callPackage android-nixpkgs { };

        android-sdk = android-nix.sdk (sdkPkgs: with sdkPkgs; [
          cmdline-tools-latest
          build-tools-35-0-0
          platform-tools
          platforms-android-36
          platforms-android-34
          platforms-android-35
          platforms-android-31
          emulator
        ]);

        buildInputs = [
          # pkgs.android-studio
          pkgs.android-studio
          pkgs.fontconfig
          pkgs.glibcLocales
          pkgs.gtk3
          pkgs.glib
          pkgs.xorg.libXi
          pkgs.ffmpeg
          pkgs.mpv
          pkgs.openjdk17
          android-sdk
          pkgs.flutter
          pkgs.alsa-lib
          pkgs.pkg-config
          pkgs.sysprof
          pkgs.sysprof.dev
          pkgs.libepoxy
          pkgs.libass
          pkgs.libxdmcp
          pkgs.xorg.libX11
          pkgs.xorg.libXext
          pkgs.xorg.libXrender
          pkgs.xorg.libXrandr
          pkgs.wayland
          pkgs.libxkbcommon
          pkgs.libva
        ];
      in {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;

          shellHook = ''
            export LANG=en_US.UTF-8
            export LC_ALL=en_US.UTF-8
            export FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf
            export GDK_BACKEND=x11

            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH

            export PKG_CONFIG_PATH="${pkgs.alsa-lib}/lib/pkgconfig:${pkgs.sysprof.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
            export CMAKE_PREFIX_PATH="${pkgs.alsa-lib}:${pkgs.alsa-lib.dev}:$CMAKE_PREFIX_PATH"

            export TMP_SDK_ROOT=$(mktemp -d -t android-sdk-XXXXXX)
            cp -r ${android-sdk}/share/android-sdk/* "$TMP_SDK_ROOT" 2>/dev/null || true

            export ANDROID_SDK_ROOT=$TMP_SDK_ROOT
            export ANDROID_HOME=$ANDROID_SDK_ROOT
            export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$PATH

            echo "Ephemeral Android SDK initialized at $ANDROID_SDK_ROOT"
          '';
        };
      }
    );
}