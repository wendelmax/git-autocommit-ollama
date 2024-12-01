#!/bin/bash

# Função para exibir o uso do script
usage() {
  echo "Uso: $0 [--tag <código_do_projeto>]"
  exit 1
}

# Variável para armazenar a tag opcional
tag=""

# Parse de argumentos para a opção --tag
while [[ "$1" != "" ]]; do
    case $1 in
        --tag )
            shift
            tag="$1 "
            ;;
        * )
            usage
            ;;
    esac
    shift
done

# Inicia o servidor Ollama
ollama serve &

# Aguarda alguns segundos para garantir que o servidor está ativo
sleep 3

# Obtém o status do Git
status=$(git status -vv)

# Faz uma requisição curl para o Ollama, enviando o status como prompt
commit_message=$(curl -s -X POST http://localhost:11411/v1/generate \
  -H "Content-Type: application/json" \
  -d '{
        "prompt": "Baseado no seguinte resultado do git status, gere uma mensagem de commit concisa e direta:\n'"$status"'"
      }' | jq -r '.message')

# Verifica se a resposta está vazia
if [[ -z "$commit_message" ]]; then
  echo "Erro: Não foi possível gerar uma mensagem de commit com Ollama."
  kill %1  # Finaliza o servidor Ollama
  exit 1
fi

# Prepara a mensagem de commit com a tag, se fornecida
commit_message="${tag}${commit_message}"

# Adiciona e faz o commit com a mensagem gerada pelo Ollama
git add .
git commit -m "$commit_message"

# Finaliza o servidor Ollama
kill %1

# Imprime apenas a mensagem do commit
echo "$commit_message"
