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
        platformVersions = [ 31 34 35 36 37 ];
        abiVersions = [ "armeabi-v7a" "arm64-v8a" "x86_64" ];
        ndkVersion = "28.2.13676358";
        
        ciAndroidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ buildToolsVersion ];
          platformVersions = platformVersions;
          includeSystemImages = false;
          includeEmulator = false;  
          abiVersions = abiVersions;
          ndkVersions = [ ndkVersion ];
          cmakeVersions = [ "3.22.1" ];
          includeNDK = true;
        };

        devAndroidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ buildToolsVersion ];
          platformVersions = platformVersions;
          includeSystemImages = true;
          includeEmulator = true;  
          abiVersions = abiVersions;
          ndkVersions = [ ndkVersion ];
          cmakeVersions = [ "3.22.1" ];
          systemImageTypes = [ 
            "default" 
            #"android-tv" 
          ];
          includeNDK = true;
        };

        androidPackages = with pkgs; [
          jdk17
          openjdk17
        ];

        linuxPackages = with pkgs; [
          gtk3
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
          libsecret
          fontconfig
          glib
          libxi
          ffmpeg
          mpv
          alsa-lib
          pkg-config
          sysprof
          sysprof.dev
        ];

        commonPackages = with pkgs; [
          flutter
          cmake
          clang
          ninja
          glibcLocales
          cacert
        ];

        androidHook = sdk: ''
          export JAVA_HOME="${pkgs.openjdk17}"
          export ANDROID_NDK_ROOT="${sdk}/libexec/android-sdk/ndk/${ndkVersion}"
          export GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
          export ANDROID_SDK_ROOT="${sdk}/libexec/android-sdk";
        '';

        linuxHook = ''
          export FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf
          export CMAKE_PREFIX_PATH="${pkgs.alsa-lib}:${pkgs.alsa-lib.dev}:$CMAKE_PREFIX_PATH"
          export CMAKE_INCLUDE_PATH="${pkgs.alsa-lib.dev}/include:$CMAKE_INCLUDE_PATH"
          export CMAKE_LIBRARY_PATH="${pkgs.alsa-lib}/lib:$CMAKE_LIBRARY_PATH"
          export CMAKE_ARGS="-DALSA_LIBRARY=${pkgs.alsa-lib}/lib/libasound.so -DALSA_INCLUDE_DIR=${pkgs.alsa-lib.dev}/include -DCA_BUNDLE=/etc/ssl/certs/ca-bundle.crt"
          export LD_LIBRARY_PATH="${pkgs.sqlite.out}/lib:${pkgs.lib.makeLibraryPath [ pkgs.gtk3 pkgs.glib pkgs.libsecret pkgs.libepoxy pkgs.alsa-lib ]}:$LD_LIBRARY_PATH"
          export ALSA_LIBRARY="${pkgs.alsa-lib}/lib/libasound.so"
          export ALSA_INCLUDE_DIR="${pkgs.alsa-lib.dev}/include"
          export PKG_CONFIG_PATH="${pkgs.vulkan-loader}/lib/pkgconfig:${pkgs.alsa-lib}/lib/pkgconfig:${pkgs.sysprof.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
        '';

        commonHook = ''
          export LANG=en_US.UTF-8
          export LC_ALL=en_US.UTF-8
          export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
          export CURL_CA_BUNDLE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        '';

      in
      {
        
        devShells = {
          
          default = pkgs.mkShell {
            
            packages = commonPackages ++
              [ devAndroidComposition.androidsdk] ++
              androidPackages ++
              linuxPackages;

            shellHook = ''
              ${commonHook}
              ${androidHook devAndroidComposition.androidsdk}
              ${linuxHook}

              echo "Self.Tube Dev-Shell is ready!"
            '';

          };

          ciAndroid = pkgs.mkShell {
            
            packages = commonPackages ++
              [ ciAndroidComposition.androidsdk ] ++
              androidPackages;

            shellHook = ''
              ${commonHook}
              ${androidHook ciAndroidComposition.androidsdk}

              echo "Self.Tube Android-CI Shell is ready!"
            '';

          };

          ciLinux = pkgs.mkShell {
            
            packages = commonPackages ++
              linuxPackages;

            shellHook = ''
              ${commonHook}
              ${linuxHook}

              echo "Self.Tube Linux-CI Shell is ready!"
            '';

          };

        };
      }
   );
}
