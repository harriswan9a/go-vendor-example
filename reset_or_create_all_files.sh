#!/bin/sh

if [ -d "./.cache" ]; then
    rm -rf .cache
fi

if [ -d "./.vscode" ]; then
    rm -rf .vscode
fi

if [ -d "./src" ]; then
    rm -rf src
fi
if [ -d "./pkg" ]; then
    rm -rf pkg
fi

if [ -d "./bin" ]; then
    rm -rf bin
fi

# Setup environment virable
export GOPATH=`pwd`
export PATH=$GOPATH/bin:$PATH

# Setup VSCode workspace environment
mkdir .vscode
echo "{
    \"go.gopath\": \"`pwd`\"
}
" > .vscode/settings.json

# Create project structure
mkdir src src/app bin pkg

# Install govendor
go get -u github.com/kardianos/govendor
rm -rf $GOPATH/src/github.com

cd $GOPATH/src/app

echo "package app

func RunApp() {
    println(\"Done...\")
}
" > app.go

$GOPATH/bin/govendor init
$GOPATH/bin/govendor sync

cd $GOPATH/src

echo "package main

import (
    \"app\"
)

func main() {
    app.RunApp()
}
"  > main.go

go run $GOPATH/src/main.go