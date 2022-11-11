# Terragrunt version
load-asdf() {
  local asdfrc_path=".tool-versions"

  if [ -f "$asdfrc_path" ]; then
    asdf install
  fi
}
add-zsh-hook chpwd load-asdf
load-asdf

# Dot envs
load-dotenv() {
  if [ -f ".envrc" ]; then
    echo "Loading .envrc"
    export $(grep -v '^#' .envrc | xargs -0)
  elif [ -f ".env" ]; then
    echo "Loading .env"
    export $(grep -v '^#' .env | xargs -0)
  fi
}
add-zsh-hook chpwd load-dotenv
load-dotenv
