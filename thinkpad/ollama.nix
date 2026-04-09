# #      _ _                               _
#   ___ | | | __ _ _ __ ___   __ _   _ __ (_)_  __
#  / _ \| | |/ _` | '_ ` _ \ / _` | | '_ \| \ \/ /
# | (_) | | | (_| | | | | | | (_| |_| | | | |>  <
#  \___/|_|_|\__,_|_| |_| |_|\__,_(_)_| |_|_/_/\_\

final: prev: {
  ollama-rocm = prev.stdenv.mkDerivation rec {
    pname = "ollama-bin";
    version = "0.20.4";

    srcs = [
      (prev.fetchurl {
        url =
          "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-amd64.tar.zst";
        hash = "sha256-WmiUx4z4Ae+EKUn/XPmGAk314SrgcV9sTPSbHyjb4FI=";
      })
      (prev.fetchurl {
        url =
          "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-amd64-rocm.tar.zst";
        hash = "sha256-QLo+J/+xyeLFnDFV9+Ai7qSimN90OqdBaHODEu9qj4Q=";
      })
    ];

    sourceRoot = ".";

    nativeBuildInputs = [ prev.zstd prev.gnutar prev.makeWrapper ];

    buildInputs = [
      prev.stdenv.cc.cc
      prev.clinfo
      prev.rocmPackages.clr
      prev.rocmPackages.hipblas
      prev.rocmPackages.rocblas
    ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/opt/ollama-base
      mkdir -p $out/opt/ollama-rocm
      mkdir -p $out/bin

      ${prev.zstd}/bin/zstd -dc ${
        builtins.elemAt srcs 0
      } | ${prev.gnutar}/bin/tar -x -C $out/opt/ollama-base
      ${prev.zstd}/bin/zstd -dc ${
        builtins.elemAt srcs 1
      } | ${prev.gnutar}/bin/tar -x -C $out/opt/ollama-rocm

      BASE_EXE=$(find $out/opt/ollama-base -type f -name "ollama" | head -n 1)
      chmod +x "$BASE_EXE"

      ROCM_DIR=$(find $out/opt/ollama-rocm -type d -name "rocm" | head -n 1)

      makeWrapper "$BASE_EXE" "$out/bin/ollama" \
        --prefix LD_LIBRARY_PATH : "${
          prev.lib.makeLibraryPath buildInputs
        }:$ROCM_DIR" \
        --set OLLAMA_MODELS "/var/lib/ollama/models"

      echo "Success: Created wrapper at $out/bin/ollama"
    '';

    meta = {
      description = "Ollama binary with ROCm support (v${version})";
      platforms = prev.lib.platforms.linux;
      mainProgram = "ollama";
    };
  };
}

