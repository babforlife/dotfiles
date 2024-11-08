# check if scoop is installed
if ! command -v scoop &> /dev/null
then
    echo "scoop could not be found, installing scoop"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
else
    echo "scoop is already installed"
fi

# import scoop apps form scoop-export.json
scoop import scoop-export.json

# setup neovim editor in environment variable
setx EDITOR "$HOME/scoop/shims/nvim.exe"

# apply chezmoi dotfiles
read -p "Do you want to apply chezmoi dotfiles? (y/n) " -n 1 reply
if [[ $reply =~ ^[Yy]$ ]]
then
    # check if chezmoi is installed
    if ! command -v chezmoi &> /dev/null
    then
        echo "chezmoi could not be found, installing chezmoi"
        scoop install chezmoi
    fi
chezmoi init --apply --verbose https://github.com/babforlife/dotfiles.git
fi
