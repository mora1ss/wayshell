{ lib
, stdenv
, callPackage
, makeWrapper
, python3
, qt6
, adw-gtk3
, bluez
, ddcutil
, cliphist
, fastfetch
, ffmpeg
, file
, gpu-screen-recorder
, grim
, imagemagick
, jq
, kitty
, matugen
, networkmanager
, pciutils
, playerctl
, power-profiles-daemon
, satty
, util-linux
, wf-recorder
, wireplumber
, wl-clipboard
, xdg-desktop-portal-gtk
, tesseract
, zbar
, quickshell
, libpulseaudio
, pipewire
, serpantinum-audio ? callPackage ./audio.nix { }
, serpantinum-gamma ? callPackage ./gamma.nix { }
, serpantinum-core ? callPackage ./core.nix { }
, ...
}:
let
  pname = "wayshell";
  version = lib.strings.trim (builtins.readFile ../version.txt);
  pathDeps = [
    bluez
    ddcutil
    cliphist
    fastfetch
    ffmpeg
    file
    gpu-screen-recorder
    grim
    imagemagick
    jq
    kitty
    matugen
    networkmanager
    pciutils
    playerctl
    power-profiles-daemon
    python3
    satty
    util-linux
    wf-recorder
    wireplumber
    wl-clipboard
    xdg-desktop-portal-gtk
    tesseract
    zbar
    quickshell
    serpantinum-audio
    serpantinum-gamma
    serpantinum-core
  ];
  qtDeps = [
    quickshell
    qt6.qtwayland
    qt6.qtmultimedia
  ];
  qmlImportPath = lib.concatMapStringsSep ":" (pkg: "${pkg}/lib/qt-6/qml") qtDeps;
  qtPluginPath = lib.concatMapStringsSep ":" (pkg: "${pkg}/lib/qt-6/plugins") qtDeps;
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;
  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions (
      map (p: ../. + "/${p}") [ "bin" "src" "config" "compositors" "version.txt" ]
    );
  };
  nativeBuildInputs = [ makeWrapper qt6.wrapQtAppsHook ];
  buildInputs = qtDeps ++ [ libpulseaudio pipewire ];
  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/${finalAttrs.pname}"
    cp -r src/. "$out/share/${finalAttrs.pname}/"
    rm -f "$out/share/${finalAttrs.pname}/version.txt"
    cp -r config "$out/share/${finalAttrs.pname}/config"
    cp version.txt "$out/share/${finalAttrs.pname}/version.txt"
    find "$out/share/${finalAttrs.pname}" -type f \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} +
    install -Dm755 bin/wayshell  "$out/bin/.wayshell-wrapped"
    install -Dm755 bin/wayshelld "$out/bin/.wayshelld-wrapped"
    ln -s "${lib.getExe serpantinum-audio}" "$out/bin/serpantinum-audio"
    ln -s "${lib.getExe serpantinum-gamma}" "$out/bin/serpantinum-gamma"
    ln -s "${lib.getExe serpantinum-core}" "$out/bin/serpantinum-core"
    runHook postInstall
  '';
  postFixup = ''
    for bin in wayshell wayshelld; do
      makeWrapper "$out/bin/.$bin-wrapped" "$out/bin/$bin" \
        "''${qtWrapperArgs[@]}" \
        --prefix QML2_IMPORT_PATH : "${qmlImportPath}" \
        --prefix QT_PLUGIN_PATH : "${qtPluginPath}" \
        --set WAYSHELL_DIR "$out/share/${finalAttrs.pname}" \
        --set WAYSHELL_VERSION "${finalAttrs.version}" \
        --prefix PATH : "${lib.makeBinPath pathDeps}"
    done
  '';
  passthru = { inherit pathDeps qtDeps serpantinum-audio serpantinum-gamma serpantinum-core; };
  meta = with lib; {
    description = "A desktop shell built for YOU";
    homepage = "https://github.com/mora1ss/wayshell";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "wayshell";
  };
})
