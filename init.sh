#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

PROJECT_NAME=$1

## Create Project
mkdir ${PROJECT_NAME} && cd ${PROJECT_NAME}

## Create readme file
echo "$PROJECT_NAME" > README.md

## Create folders
#mkdir src 
#mkdir src/ext && mkdir src/module && mkdir src/test
mkdir build

## Copy template files
#cp ../template/README.md && sed -i '' -e "s/# Template/$PROJECT_NAME/" README.md
cp -r ../template/* .

##Change the name of the project. sed command expect an extension argument in OsX that's why the ''
sed -i '' -e "s/GloryPath/$PROJECT_NAME/" CMakeLists.txt

## Init Repo
git init -b master

## Init submodules
git submodule add https://github.com/google/googletest.git src/ext/google/googletest
git submodule add https://github.com/google/benchmark.git src/ext/google/benchmark

## Compile
cd build
cmake ..
make -j 16

## Run dummy tests
./${PROJECT_NAME}_tests

## First commit
cd .. && git commit -a -m "init commit"
