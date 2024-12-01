#!/usr/bin/env python3
import sys
import os
import argparse
from pathlib import Path

# Adiciona o diretório pai ao PYTHONPATH
sys.path.append(str(Path(__file__).parent.parent))
from utils import Utils, GitAutoCommitError

def main():
    # Configuração do parser de argumentos
    parser = argparse.ArgumentParser(description='Gera commits automáticos usando Ollama')
    parser.add_argument('--tag', help='Tag opcional para o commit')
    parser.add_argument('--config', default='../config.json', help='Caminho para o arquivo de configuração')
    args = parser.parse_args()

    try:
        # Inicializa o utilitário com o arquivo de configuração
        config_path = os.path.join(os.path.dirname(__file__), args.config)
        with Utils(config_path) as utils:
            # Verifica dependências
            utils.check_dependencies()

            # Verifica se há mudanças para commit
            if not utils.check_git_changes():
                print("Não há mudanças para commit")
                return

            # Inicia o Ollama
            utils.start_ollama()

            # Obtém o status do Git
            status = utils.get_git_status()

            # Gera a mensagem de commit
            message = utils.generate_commit_message(status)

            # Preview e edição da mensagem
            message = utils.preview_and_edit(message)

            # Faz o commit
            utils.make_commit(message, args.tag)

            print(f"\nCommit realizado com sucesso: {message}")

    except GitAutoCommitError as e:
        print(f"Erro: {str(e)}", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nOperação cancelada pelo usuário")
        sys.exit(1)
    except Exception as e:
        print(f"Erro inesperado: {str(e)}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
