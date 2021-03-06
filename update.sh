#!/bin/bash
set -e # script 실행 도중 에러 발생시 script 멈춤
set -o pipefail # 파이프 사용시 오류 코드(non-zero exit code)를 이어받는다

ZSH_PATH="${PWD}/zsh";
VIM_PATH="${PWD}/vim";

function check_zsh() {
    echo -e "\n-> Update ~/.zshrc ..."
    ORIGIN="${HOME}/.zshrc"
    
    if [ -f "${ORIGIN}" ]; then
      rm "${ORIGIN}"
      echo "Delete existing ~/.zshrc file"
    elif [ -L "${ORIGIN}" ]; then
      rm "${ORIGIN}"
      echo "Delete existing ~/.zshrc symlink"
    else
      echo "~/.zshrc not exists"
    fi

    ln -s "${ZSH_PATH}/.zshrc" "${ORIGIN}";
    echo "Success to put symlink of ~/.zshrc"
}

function check_vim() {
    echo -e "\n-> Update ~/.vimrc ..."
    ORIGIN="${HOME}/.vimrc"

    if [ -f "${ORIGIN}" ]; then
      rm "${ORIGIN}"
      echo "Delete existing ~/.vimrc file"
    elif [ -L "${ORIGIN}" ]; then
      rm "${ORIGIN}"
      echo "Delete existing ~/.vimrc symlink"
    else
      echo "~/.vimrc not exists"
    fi
    
    ln -s "${VIM_PATH}/.vimrc" "${ORIGIN}";
    echo "Success to put symlink of ~/.vimrc"
}

function get_zsh_plugins() {
    echo -e "\n-> Get zsh plugins ..."

    ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
    ZSH_SYNTAX_HIGHLIGHTING="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
    ZSH_AUTOSUGGESTIONS="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

    if [ -d "${ZSH_SYNTAX_HIGHLIGHTING}" ]; then
      echo "Zsh-syntax-highlighting already exists"
    else
      echo "Git clone zsh-syntax-highlighting"
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_SYNTAX_HIGHLIGHTING}"
    fi

    if [ -d "${ZSH_AUTOSUGGESTIONS}" ]; then
      echo "Zsh-autosuggestions already exists"
    else
      echo "Git clone zsh-autosuggestions"
      git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_AUTOSUGGESTIONS}"
    fi
}

function update() {
    git pull origin master

    check_zsh
    get_zsh_plugins

    check_vim
}

# 프롬프트로 계속 진행할 것인지 물어본다.
IFS=''
greetings=("===================================" "\n"
           "livlikwav dotfiles update.sh" "\n"
           "===================================" "\n"
           "This may overwrite existing your current setting files in home dir.")
farewells=("\n-> SUCCESS" "\n"
           "===================================")

echo -e "${greetings[*]}"
read -p "-> Are you sure? [y/n] " yn
case $yn in
    [Yy]* )
      update
      echo -e "${farewells[*]}"
      ;; 
    * )
      echo "Not yes. close script."
      ;;
esac
