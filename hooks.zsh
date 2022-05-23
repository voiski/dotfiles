# Terraform version
load-tfswitch() {
  local tfswitchrc_path=".tfswitchrc"

  if [ -f "$tfswitchrc_path" ]; then
    tfswitch
  fi
}
add-zsh-hook chpwd load-tfswitch
load-tfswitch

# Terragrunt version
load-tgswitch() {
  local tgswitchrc_path=".tgswitchrc"

  if [ -f "$tgswitchrc_path" ]; then
    tgswitch
  fi
}
add-zsh-hook chpwd load-tgswitch
load-tgswitch

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