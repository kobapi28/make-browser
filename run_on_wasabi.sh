#!/bin/bash -xe

HOME_PATH=$PWD
TARGET_PATH=$PWD"/build"
OS_PATH=$TARGET_PATH"/wasabi"
# アプリケーションの名前をmake-browserに変更
APP_NAME="make-browser"
MAKEFILE_PATH=$HOME_PATH"/Makefile"

# buildディレクトリを作成する
if [ -d $TARGET_PATH ]
then
    echo $TARGET_PATH" exists"
else
    echo $TARGET_PATH" doesn't exist"
    mkdir $TARGET_PATH
fi

# WasabiOSをダウンロードする（https://github.com/hikalium/wasabi）
# もしスクリプトが失敗する場合は、`rm -rf build/wasabi`などで
# ダウンロードしたOSを削除する必要がある
if [ -d $OS_PATH ]
then
    echo $OS_PATH" exists"
    echo "pulling new changes..."
    echo $OS_PATH" exists"
    cd $OS_PATH
    git pull origin for_saba
else
    echo $OS_PATH" doesn't exist"
    echo "cloning wasabi project..."
    cd $TARGET_PATH
    # gh command を使うように書き換え
    gh repo clone hikalium/wasabi -- -b for_saba
fi

# アプリケーションのトップディレクトリに移動する
cd $HOME_PATH

# Makefileをダウンロードする
if [ ! -f $MAKEFILE_PATH ]; then
   echo "downloading Makefile..."
   wget https://raw.githubusercontent.com/hikalium/wasabi/main/external_app_template/Makefile
fi

# build 前にバージョンの設定
unset RUSTUP_TOOLCHAIN
# GUI が起動するように設定
export DISPLAY=0

make build
$OS_PATH/scripts/run_with_app.sh ./target/x86_64-unknown-none/release/$APP_NAME
