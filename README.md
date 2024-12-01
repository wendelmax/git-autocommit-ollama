# Git Auto Commit com Ollama

Este projeto oferece uma solução robusta para automatizar o processo de criação de mensagens de commit no Git, utilizando o serviço Ollama para gerar descrições concisas e informativas das mudanças no código. O projeto suporta tanto Windows quanto Linux, com recursos avançados de configuração e personalização.

## Características

- ✨ Geração inteligente de mensagens de commit usando Ollama
- 🌍 Suporte para múltiplos idiomas (PT/EN)
- 🏷️ Suporte para tags de projeto personalizadas
- 📝 Conventional Commits integrado
- 👀 Preview e edição de mensagens antes do commit
- ⚙️ Configuração flexível via arquivo JSON
- 🔒 Tratamento robusto de erros
- 🚀 Modo daemon opcional para melhor performance

## Pré-requisitos

1. **Python 3.7+**: Necessário para executar os scripts
2. **Git**: Certifique-se de que o Git está instalado e configurado
3. **Ollama**: Necessário para a geração de mensagens (instruções abaixo)

### Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/git-autocommit-ollama.git
   cd git-autocommit-ollama
   ```

2. Instale as dependências Python:
   ```bash
   pip install -r requirements.txt
   ```

3. Instale o Ollama seguindo as instruções em [ollama.com](https://ollama.com)

## Configuração

O arquivo `config.json` na raiz do projeto permite personalizar diversos aspectos:

```json
{
  "ollama": {
    "url": "http://localhost:11411",
    "model": "llama2",
    "timeout": 30,
    "daemon_mode": false
  },
  "commit": {
    "language": "pt",
    "conventional_commits": true,
    "preview_before_commit": true,
    "allow_edit": true
  },
  "default_tags": {
    "project1": "[PROJ1]",
    "project2": "[PROJ2]"
  }
}
```

## Uso

### Commit Básico

```bash
# Linux
python linux/git_autocommit_ollama.py

# Windows
python windows\git_autocommit_ollama.py
```

### Commit com Tag

```bash
# Linux
python linux/git_autocommit_ollama.py --tag "[PROJ1]"

# Windows
python windows\git_autocommit_ollama.py --tag "[PROJ1]"
```

### Usando Configuração Personalizada

```bash
python git_autocommit_ollama.py --config /caminho/para/config.json
```

## Estrutura do Projeto

```
git-autocommit-ollama/
├── config.json           # Configuração global
├── requirements.txt      # Dependências Python
├── utils.py             # Módulo de utilitários compartilhado
├── linux/
│   ├── git_autocommit_ollama.py  # Script principal Linux
│   └── README.md                 # Documentação Linux
└── windows/
    ├── git_autocommit_ollama.py  # Script principal Windows
    └── README.md                 # Documentação Windows
```

## Troubleshooting

### Problemas Comuns

1. **Ollama não está respondendo**
   - Verifique se o serviço está rodando
   - Verifique a URL na configuração
   - Aumente o timeout se necessário

2. **Mensagens em idioma errado**
   - Verifique a configuração "language" no config.json

3. **Erro de dependências**
   - Execute `pip install -r requirements.txt`
   - Verifique se todas as dependências estão instaladas

## Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Distribuído sob a Licença MIT. Veja `LICENSE` para mais informações.

## Contato

Seu Nome - [@seu_twitter](https://twitter.com/seu_twitter)

Link do Projeto: [https://github.com/seu-usuario/git-autocommit-ollama](https://github.com/seu-usuario/git-autocommit-ollama)
