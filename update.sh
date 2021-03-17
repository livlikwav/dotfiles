#!/bin/bash
set -e # script 실행 도중 에러 발생시 script 멈춤
set -o pipefail # 파이프 사용시 오류 코드(non-zero exit code)를 이어받는다

echo "Update configs by livlikwav's dotfiles ..."

DOTFILES_PATH="${PWD}";
ZSH_PATH="${PWD}/zsh";
VIM_PATH="${PWD}/vim";

git pull origin master;

function update() {
    rm "${HOME}"/.zshrc;
    rm "${HOME}"/.vimrc;

    ln -s "${ZSH_PATH}"/.zshrc "${HOME}"/.zshrc;
    ln -s "${VIM_PATH}"/.vimrc "${HOME}"/.vimrc;
}

# 프롬프트로 계속 진행할 것인지 물어본다.
read -p "This may overwrite existing your current setting files in home dir. Are you sure? [y/n] " yn
case $yn in
    [Yy]* ) update;; 
    * ) echo "Not yes. close script.";;
esac
