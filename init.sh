#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

PROJECT_NAME=$1

## Create Project
mkdir ${PROJECT_NAME} && cd ${PROJECT_NAME}

## Create build folder
mkdir build

## Copy template files
cp -r ../template/* .
cp -r ../template/.vscode .
cp ../template/.gitignore .

##Change the name of the executables.
sed -i '' -e "s/Template_executable/${PROJECT_NAME}_executable/" .vscode/launch.json
sed -i '' -e "s/Template_tests/${PROJECT_NAME}_tests/" .vscode/launch.json

##Change the name of the project. sed command expect an extension argument in OsX that's why the ''
sed -i '' -e "s/GloryPath/$PROJECT_NAME/" CMakeLists.txt
sed -i '' -e "s/# Template/$PROJECT_NAME/" README.md

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
cd ..
git add *
git add .gitignore
git add .vscode
git commit -m "init commit"