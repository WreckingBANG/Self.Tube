{ pkgs, config, lib, ... }:

{
  android = {
    enable = true;
    flutter.enable = true;

    buildTools.version = [ "36.0.0" ];

    platforms.version = [ "34" "35" "36" "37" ];

    extraLicenses = [
      "android-sdk-preview-license"
      "android-sdk-license"
      "android-sdk-arm-dbt-license"
    ];
  };
}

#Letzte funktionale Version
#{ pkgs, config, lib, ... }: {
#
#  android = {
#    enable = true;
#    flutter.enable = true;
#
#    buildTools.version = [ "34.0.0" "35.0.0" "36.0.0" ];
#    platforms.version = [ "34" "35" "36" ];
#
#    extraLicenses = [
#      "android-sdk-preview-license"
#      "android-sdk-license"
#      "android-sdk-arm-dbt-license"
#    ];
#  };
#
#  env = {
#    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
#      pkgs.stdenv.cc.cc.lib
#      pkgs.zlib
#      pkgs.glibc
#    ];
#
#    GRADLE_OPTS = lib.mkForce "-Dorg.gradle.project.android.aapt2FromMavenOverride=${config.env.ANDROID_HOME}/build-tools/36.0.0/aapt2";
#  };
#
#  packages = [
#    pkgs.unzip
#    pkgs.usbutils
#  ];
#}
#
