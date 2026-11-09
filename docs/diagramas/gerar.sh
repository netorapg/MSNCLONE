#!/usr/bin/env bash
# Gera os PNGs dos diagramas. Requer o comando plantuml, ou java com plantuml.jar nesta pasta.
set -euo pipefail
cd "$(dirname "$0")"
if command -v plantuml >/dev/null; then
  plantuml -tpng -o ../../static/core/diagramas *.puml
else
  java -jar plantuml.jar -tpng -o ../../static/core/diagramas *.puml
fi
