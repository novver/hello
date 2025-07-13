{ ... }:

let

  rustOverlay = import (builtins.fetchTarball {
    url = "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
  });

  pkgs = import <nixpkgs> {
    overlays = [ rustOverlay ];
  };

  pkgNames = [
    "zlib"
    "glib"
    "gtk3"
    "webkitgtk_4_1"
    "pango"
    "at-spi2-atk"
    "atkmm"
    "cairo"
    "gdk-pixbuf"
    "libsoup_3"
    "harfbuzz"
    "librsvg"
    "openssl"
    "gobject-introspection"
  ];
in
{
  channel = "stable-25.05";

  packages = with pkgs; [
    
    (rust-bin.stable.latest.default.override {
      targets = [ "aarch64-linux-android" ];
    })

    gcc
    htop
    bun
    cargo-tauri
    pkg-config

    # Tauri android
    jdk21_headless
    android-tools
    gradle

    # Tauri apps
    at-spi2-atk
    atkmm
    cairo
    gdk-pixbuf
    zlib
    glib
    gtk3
    harfbuzz
    librsvg
    libsoup_3
    pango
    webkitgtk_4_1
    openssl
    gobject-introspection

    # Dummy display
    dbus
    xvfb-run
    xorg.xauth
    xorg.xhost
    xorg.xorgserver
    xorg.xwd
    imagemagick
    openbox
  ];

  env = {

    ANDROID_HOME=/home/user/.androidsdkroot;
    NDK_HOME=/home/user/.androidsdkroot/ndk/23.1.7779620;
    
    PKG_CONFIG_PATH = "${builtins.concatStringsSep ":" (
      builtins.map (name: "${pkgs.${name}.dev}/lib/pkgconfig") pkgNames
    )}:$PKG_CONFIG_PATH";

    RUSTFLAGS = "-C link-arg=-v -C link-arg=-L${pkgs.zlib}/lib";
    
  };

  idx = {
    extensions = [];
    previews = {
      enable = true;
      previews = {};
    };
    workspace = {
      onCreate = {};
      onStart = {
        previews = {
          # android = { manager = "web"; }; 
        };
      };
    };
  };
}
