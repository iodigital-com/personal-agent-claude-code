# Run with: powershell -ExecutionPolicy Bypass -File .\start-personal-agent.ps1

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Load .env variables into environment
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^\s*([^#\s][^=]*)=(.*)$") {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            [System.Environment]::SetEnvironmentVariable($key, $value, "Process")
        }
    }
}

docker compose up -d

$token = [System.Environment]::GetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "Process")

if ($token) {
    docker compose exec `
        -e "ANTHROPIC_AUTH_TOKEN=$token" `
        claude-agent `
        zsh -c "ANTHROPIC_AUTH_TOKEN=$token claude --dangerously-skip-permissions; exec zsh"
} else {
    Write-Warning "ANTHROPIC_AUTH_TOKEN not set in .env - launching shell without starting Claude."
    docker compose exec claude-agent zsh
}
