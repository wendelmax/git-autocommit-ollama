Aqui está o README principal atualizado, agora com links para os arquivos `README.md` dentro das pastas específicas para **Linux** e **Windows**.

---

# Git Auto Commit com Ollama

Este projeto oferece um script para automatizar o processo de criação de uma mensagem de commit no Git, utilizando o serviço Ollama para gerar uma descrição concisa e informativa das mudanças no código. O repositório está organizado com scripts separados para **Linux** e **Windows**, permitindo fácil configuração em ambos os sistemas operacionais.

## Pré-requisitos

1. **Git**: Certifique-se de que o Git está instalado e configurado em seu sistema.
2. **Ollama**: Necessário para a geração automática de mensagens. Consulte a seção abaixo para obter instruções de instalação.
3. **jq** (apenas para Linux): Utilizado para processar JSON.

### Instalação do Ollama

O Ollama é uma ferramenta que fornece modelos de linguagem natural e é necessária para a geração das mensagens de commit. Siga os passos para instalá-lo:

1. Acesse o [site oficial do Ollama](https://ollama.com/) e baixe a versão mais recente para o seu sistema operacional.
2. Siga as instruções de instalação fornecidas pelo site. O Ollama fornece instaladores que facilitam o processo em sistemas Windows, macOS e Linux.
3. Verifique a instalação abrindo um terminal e digitando o comando abaixo. Este comando deve exibir as informações de versão do Ollama, confirmando que ele está instalado corretamente:

   ```bash
   ollama --version
   ```

### Instalando `jq` no Linux

Para instalar o `jq`, necessário para o script Linux, use o comando:

```bash
sudo apt install jq  # Em sistemas baseados em Debian
```

## Configuração

No repositório, você encontrará duas pastas principais com scripts e instruções detalhadas para cada sistema operacional:

- [Linux](./linux/README.md): Contém o script e as instruções específicas para sistemas Linux.
- [Windows](./windows/README.md): Contém o script e as instruções específicas para sistemas Windows.

Escolha a pasta correspondente ao seu sistema operacional e siga as instruções para configurar o script.

## Estrutura de Pastas

```
git-autocommit-ollama/
├── linux/
│   ├── git_autocommit_ollama.sh  # Script para Linux
│   └── README.md                 # Instruções para Linux
├── windows/
│   ├── git_autocommit_ollama.ps1 # Script para Windows
│   └── README.md                 # Instruções para Windows
└── README.md                     # Este arquivo
```

Cada pasta inclui um arquivo `README.md` com instruções detalhadas sobre como configurar e usar o script para o sistema específico.

## Uso

Após configurar o script de acordo com as instruções específicas (em `linux/` ou `windows/`):

1. Para fazer um commit sem uma tag, execute o comando normalmente:
   - **Linux**:
     ```bash
     git-autocommit
     ```
   - **Windows**:
     ```powershell
     git-autocommit
     ```

2. Para fazer um commit com uma tag de projeto, use o argumento `--tag` seguido do código do projeto (exemplo: `[Projeto1][Task1]`):
   - **Linux**:
     ```bash
     git-autocommit --tag "[Projeto1][Task1]"
     ```
   - **Windows**:
     ```powershell
     git-autocommit --tag "[Projeto1][Task1]"
     ```

Isso permitirá que você insira qualquer prefixo ou tag antes da mensagem gerada pelo Ollama, conforme as necessidades do projeto.