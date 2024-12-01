#!/bin/bash

# Verifica se o Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "Python 3 não está instalado. Por favor, instale-o primeiro."
    exit 1
fi

# Verifica se o pip está instalado
if ! command -v pip3 &> /dev/null; then
    echo "pip3 não está instalado. Por favor, instale-o primeiro."
    exit 1
fi

# Instala as dependências Python
pip3 install -r ../requirements.txt

# Cria o diretório bin se não existir
mkdir -p ~/bin

# Cria o script wrapper
cat > ~/bin/git-autocommit << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 /home/wendel/work/novo/git-autocommit-ollama/linux/git_autocommit_ollama.py "$@"
EOF

# Torna o script executável
chmod +x ~/bin/git-autocommit

# Adiciona ~/bin ao PATH se ainda não estiver
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    echo "Adicionado ~/bin ao PATH. Por favor, reinicie seu terminal ou execute 'source ~/.bashrc'"
fi

echo "Instalação concluída! Você pode usar o comando 'git-autocommit' de qualquer diretório."
