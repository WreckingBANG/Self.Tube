{
  description = "100% Contained FHS Android Dev Shell";

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
          emulator
        ]);

        deps = with pkgs; [
          flutter
          android-sdk
          # Gradle 8.13 läuft stabiler mit JDK 21
          jdk17
          pkg-config
          libsecret
          glib
          gtk3
          libepoxy
          xorg.libX11
          xorg.libXext
          xorg.libXrender
          xorg.libXi
          xorg.libXrandr
          libxkbcommon
          zlib
          ncurses
          expat
          fontconfig
          freetype
          alsa-lib
          nspr
          nss
          ffmpeg
        ];

      in {
        devShells.default = (pkgs.buildFHSEnv {
          name = "self-tube-env";
          targetPkgs = pkgs: deps;
          multiPkgs = pkgs: with pkgs; [ zlib ];

          profile = ''
            export LANG=en_US.UTF-8
            export GDK_BACKEND=x11
            
            # Korrekter dynamischer Linker Pfad für NixOS FHS
            export NIX_LD=$(ldd $(which ls) | grep ld-linux-x86-64.so.2 | awk '{print $1}')
            export NIX_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
            
            # Java Home setzen für Gradle
            export JAVA_HOME=${pkgs.jdk17}
            export PATH=$JAVA_HOME/bin:$PATH

            # Ephemeral SDK Setup
            export TMP_SDK_ROOT=$(mktemp -d -t android-sdk-XXXXXX)
            cp -r ${android-sdk}/share/android-sdk/* "$TMP_SDK_ROOT" 2>/dev/null || true
            export ANDROID_SDK_ROOT=$TMP_SDK_ROOT
            export ANDROID_HOME=$ANDROID_SDK_ROOT
            export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$PATH

            echo "🛠️ FHS Shell geladen mit JDK 21."
          '';
        }).env;
      }
    );
}
