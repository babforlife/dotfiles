# Check if Scoop is installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Output "Scoop could not be found, installing Scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

# Prompt user to apply Chezmoi dotfiles
$reply = Read-Host "Do you want to apply Chezmoi dotfiles? (y/n)"
if ($reply -match '^[Yy]$') {
    # Check if Chezmoi is installed
    if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
        Write-Output "Chezmoi could not be found, installing Chezmoi"
        scoop bucket add extras
        scoop install chezmoi
    }
    # Initialize and apply Chezmoi dotfiles
    chezmoi init --apply --verbose https://github.com/babforlife/dotfiles.git
}

# Import Scoop apps from scoop-export.json
if (Test-Path "./scoop-export.json") {
    scoop import ./scoop-export.json
} else {
    Write-Output "scoop-export.json file not found. Skipping import."
}

# Set up Neovim as the default editor in environment variable
$editorPath = "$HOME\scoop\shims\nvim.exe"
[Environment]::SetEnvironmentVariable("EDITOR", $editorPath, [EnvironmentVariableTarget]::User)

# Clone Nushell scripts
$configPath = "$HOME\.config\"
if (-not (Test-Path -Path $configPath)) {
    New-Item -ItemType Directory -Path $configPath | Out-Null
}
git clone https://github.com/nushell/nu_scripts.git "$configPath\nu_scripts"
