# Verifica se o Python está instalado
try {
    python --version
} catch {
    Write-Host "Python não está instalado. Por favor, instale-o primeiro."
    exit 1
}

# Verifica se o pip está instalado
try {
    pip --version
} catch {
    Write-Host "pip não está instalado. Por favor, instale-o primeiro."
    exit 1
}

# Instala as dependências Python
pip install -r ..\requirements.txt

# Cria o diretório para scripts se não existir
$scriptsDir = "$env:USERPROFILE\bin"
if (-not (Test-Path $scriptsDir)) {
    New-Item -ItemType Directory -Path $scriptsDir
}

# Cria o script wrapper
$wrapperContent = @"
@echo off
python $PSScriptRoot\..\windows\git_autocommit_ollama.py %*
"@

Set-Content -Path "$scriptsDir\git-autocommit.bat" -Value $wrapperContent

# Adiciona o diretório ao PATH do usuário
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$scriptsDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$scriptsDir", "User")
    Write-Host "Adicionado $scriptsDir ao PATH do usuário."
    Write-Host "Por favor, reinicie seu terminal para que as mudanças tenham efeito."
}

Write-Host "Instalação concluída! Você pode usar o comando 'git-autocommit' de qualquer diretório."
