Write-Host "🚀 Iniciando limpeza profunda do sistema..." -ForegroundColor Cyan

# Função de remover arquivos com verificação
Function Remove-Files($Path) {
    if (Test-Path $Path) {
        Write-Host "🗑️ Limpando: $Path" -ForegroundColor Yellow
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "⚠️ Caminho não encontrado: $Path" -ForegroundColor DarkGray
    }
}

# Limpeza de Temp do usuário
Remove-Files "$env:LOCALAPPDATA\Temp\*"
Remove-Files "$env:TEMP\*"

# Limpeza de Temp do sistema
Remove-Files "C:\Windows\Temp\*"

# Limpeza de cache do Windows Update
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Files "C:\Windows\SoftwareDistribution\Download\*"
Start-Service wuauserv -ErrorAction SilentlyContinue

# Limpeza de logs do sistema
Remove-Files "C:\Windows\Logs\*"

# Limpeza de arquivos de cache do navegador Edge (nativo)
Remove-Files "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*"

# Limpeza de cache do Explorer
Remove-Files "$env:APPDATA\Microsoft\Windows\Recent\*"

# Limpeza de mini dumps (erros e crashes)
Remove-Files "C:\Windows\Minidump\*"

# Limpeza de Prefetch
Remove-Files "C:\Windows\Prefetch\*"

# Limpeza de arquivos de relatório de erros
Remove-Files "C:\ProgramData\Microsoft\Windows\WER\*"

# Limpeza de thumbnails (imagens pré-geradas)
Remove-Files "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db"

# Limpeza de cache da loja da Microsoft
Remove-Files "$env:LOCALAPPDATA\Packages\Microsoft.WindowsStore_*\LocalCache\*"

# Limpeza de cache do DirectX
Remove-Files "$env:LOCALAPPDATA\D3DSCache\*"

# Limpeza de arquivos residuais de drivers antigos
Remove-Files "C:\Windows\System32\DriverStore\FileRepository\*"

# Limpeza de Windows.old (se existir)
Remove-Files "C:\Windows.old\*"

Write-Host "✅ Limpeza de arquivos concluída." -ForegroundColor Green

# Liberar espaço com CleanMgr (opcional)
Write-Host "🧽 Executando limpeza de arquivos de sistema..." -ForegroundColor Cyan
Start-Process cleanmgr -ArgumentList '/sagerun:1'

# Limpar cache de memória Standby (se desejar)
if (Get-Command "Clear-MemoryCache" -ErrorAction SilentlyContinue) {
    Write-Host "🧠 Limpando cache de memória Standby..." -ForegroundColor Cyan
    Clear-MemoryCache
}

Write-Host "🚀 Limpeza profunda finalizada com sucesso." -ForegroundColor Green
Pause
