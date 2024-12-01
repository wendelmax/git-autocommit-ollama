import json
import os
import sys
import subprocess
import requests
import time
from typing import Optional, Dict, Any

class GitAutoCommitError(Exception):
    pass

class Utils:
    def __init__(self, config_path: str = "config.json"):
        self.config = self.load_config(config_path)
        self.ollama_process = None

    def load_config(self, config_path: str) -> Dict[Any, Any]:
        """Carrega o arquivo de configuração."""
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            raise GitAutoCommitError(f"Arquivo de configuração não encontrado: {config_path}")
        except json.JSONDecodeError:
            raise GitAutoCommitError(f"Arquivo de configuração inválido: {config_path}")

    def check_dependencies(self) -> None:
        """Verifica se todas as dependências necessárias estão instaladas."""
        # Verifica Git
        try:
            subprocess.run(["git", "--version"], check=True, capture_output=True)
        except subprocess.CalledProcessError:
            raise GitAutoCommitError("Git não está instalado ou não está no PATH")

        # Verifica Ollama
        try:
            subprocess.run(["ollama", "--version"], check=True, capture_output=True)
        except subprocess.CalledProcessError:
            raise GitAutoCommitError("Ollama não está instalado ou não está no PATH")

    def check_git_changes(self) -> bool:
        """Verifica se há mudanças para commit."""
        result = subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True)
        return bool(result.stdout.strip())

    def start_ollama(self) -> None:
        """Inicia o servidor Ollama se necessário."""
        if not self.config["ollama"]["daemon_mode"]:
            self.ollama_process = subprocess.Popen(["ollama", "serve"])
            time.sleep(3)  # Aguarda o servidor iniciar

    def stop_ollama(self) -> None:
        """Para o servidor Ollama se estiver rodando."""
        if self.ollama_process:
            self.ollama_process.terminate()
            self.ollama_process.wait()

    def get_git_status(self) -> str:
        """Obtém o status do Git."""
        result = subprocess.run(["git", "status", "-vv"], capture_output=True, text=True)
        return result.stdout

    def generate_commit_message(self, status: str) -> str:
        """Gera uma mensagem de commit usando Ollama."""
        language = self.config["commit"]["language"]
        prompt = self.config["prompts"][language] + status

        try:
            response = requests.post(
                f"{self.config['ollama']['url']}/v1/generate",
                json={"prompt": prompt},
                timeout=self.config["ollama"]["timeout"]
            )
            response.raise_for_status()
            message = response.json().get("message", "").strip()
            if not message:
                raise GitAutoCommitError("Ollama retornou uma mensagem vazia")
            return message
        except requests.RequestException as e:
            raise GitAutoCommitError(f"Erro ao comunicar com Ollama: {str(e)}")

    def preview_and_edit(self, message: str) -> str:
        """Permite visualizar e editar a mensagem de commit."""
        if not self.config["commit"]["preview_before_commit"]:
            return message

        print("\nMensagem de commit gerada:")
        print("-" * 50)
        print(message)
        print("-" * 50)

        if self.config["commit"]["allow_edit"]:
            edit = input("\nDeseja editar a mensagem? (s/N): ").lower()
            if edit == 's':
                new_message = input("Digite a nova mensagem: ").strip()
                return new_message if new_message else message

        return message

    def make_commit(self, message: str, tag: Optional[str] = None) -> None:
        """Realiza o commit com a mensagem gerada."""
        if tag:
            # Verifica se é uma tag predefinida
            tag = self.config["default_tags"].get(tag, tag)
            message = f"{tag} {message}"

        try:
            subprocess.run(["git", "add", "."], check=True)
            subprocess.run(["git", "commit", "-m", message], check=True)
        except subprocess.CalledProcessError as e:
            raise GitAutoCommitError(f"Erro ao fazer commit: {str(e)}")

    def __enter__(self):
        """Permite uso do contexto 'with'."""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Garante que o Ollama seja finalizado."""
        self.stop_ollama()
