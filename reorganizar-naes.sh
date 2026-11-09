#!/usr/bin/env bash
# Reorganiza o repositório NAES: o projeto Django (MSNCLONE/msnclone) passa a ser a raiz.
# Rode na raiz do seu clone local, com a árvore limpa (git status sem mudanças pendentes).
# Nada é enviado ao GitHub: o script cria um branch e um commit local para você revisar.
set -euo pipefail

[ -d MSNCLONE/msnclone ] || { echo "Rode na raiz do repositório NAES."; exit 1; }
[ -z "$(git status --porcelain --untracked-files=no)" ] || { echo "Há mudanças não commitadas. Faça commit ou stash antes."; exit 1; }

git checkout -b reorganiza-raiz

# 1. Tira do git o que é gerado ou não pertence ao projeto (os arquivos locais ficam no disco)
git rm -r -q --cached --ignore-unmatch MSNCLONE/msnclone/staticfiles MSNCLONE/plantuml.jar
git ls-files | grep '__pycache__/' | xargs -r git rm -q --cached
git rm -q commands.txt case.puml class.puml

# 2. Sobe o projeto Django para a raiz (inclui arquivos ocultos e não versionados, como .env e db.sqlite3)
shopt -s dotglob
mv MSNCLONE/msnclone/* .
shopt -u dotglob

# 3. Documentação e diagramas
mkdir -p docs/diagramas
mv MSNCLONE/README.md README.md
mv MSNCLONE/caso_uso_msn.puml MSNCLONE/diagrama_classes_msn.puml docs/diagramas/
rm -f MSNCLONE/gerar_diagramas.sh
[ -f MSNCLONE/plantuml.jar ] && mv MSNCLONE/plantuml.jar docs/diagramas/
rmdir MSNCLONE/msnclone MSNCLONE 2>/dev/null || echo "Aviso: sobrou algo em MSNCLONE/; confira manualmente."

cat > docs/diagramas/gerar.sh <<'EOF'
#!/usr/bin/env bash
# Gera os PNGs dos diagramas. Requer o comando plantuml, ou java com plantuml.jar nesta pasta.
set -euo pipefail
cd "$(dirname "$0")"
if command -v plantuml >/dev/null; then
  plantuml -tpng -o ../../static/core/diagramas *.puml
else
  java -jar plantuml.jar -tpng -o ../../static/core/diagramas *.puml
fi
EOF
chmod +x docs/diagramas/gerar.sh

# 4. .gitignore adequado a um projeto Django
cat > .gitignore <<'EOF'
# Python
__pycache__/
*.py[cod]
.venv/
venv/

# Django
*.sqlite3
/staticfiles/
/media/
.env

# Ferramentas
docs/diagramas/plantuml.jar
.vscode/
.idea/
.DS_Store
EOF

git add -A
git commit -q -m "Reorganiza o repositório: projeto Django na raiz

Move MSNCLONE/msnclone para a raiz, leva os diagramas para docs/diagramas
e remove do versionamento staticfiles/, __pycache__ e plantuml.jar."

echo
echo "Pronto. Revise com:  git show --stat HEAD"
echo "Teste com:           python manage.py check && python manage.py runserver"
echo "Se estiver tudo certo: git checkout master && git merge reorganiza-raiz && git push"
