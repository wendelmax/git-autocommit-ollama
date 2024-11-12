# Função para exibir o uso do script
function Show-Usage {
    Write-Output "Uso: git_autocommit_ollama.ps1 [--tag <código_do_projeto>]"
    exit 1
}

# Variável para armazenar a tag opcional
$tag = ""

# Parse de argumentos para a opção --tag
param (
    [string]$tagParam
)

if ($tagParam -ne $null) {
    $tag = "$tagParam "
}

# Inicia o servidor Ollama
Start-Process "ollama" -ArgumentList "serve"
Start-Sleep -Seconds 3

# Obtém o status do Git
$status = git status -vv

# Faz uma requisição para o Ollama usando Invoke-RestMethod
$response = Invoke-RestMethod -Uri "http://localhost:11411/v1/generate" -Method Post -Body (@{
    prompt = "Baseado no seguinte resultado do git status, gere uma mensagem de commit concisa e direta:`n$status"
} | ConvertTo-Json) -ContentType "application/json"

# Extrai a mensagem do commit
$commit_message = $response.message

# Verifica se a resposta está vazia
if (-not $commit_message) {
    Write-Output "Erro: Não foi possível gerar uma mensagem de commit com Ollama."
    Stop-Process -Name "ollama" -Force
    exit 1
}

# Prepara a mensagem de commit com a tag, se fornecida
$commit_message = "${tag}${commit_message}"

# Adiciona e faz o commit com a mensagem gerada pelo Ollama
git add .
git commit -m $commit_message

# Finaliza o servidor Ollama
Stop-Process -Name "ollama" -Force

# Imprime apenas a mensagem do commit
Write-Output $commit_message
