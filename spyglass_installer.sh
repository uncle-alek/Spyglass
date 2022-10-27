#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
BGREEN='\033[1;92m'
NC='\033[0m'

CD=$(pwd)

trap 'rm -rf $CD/Spyglass' EXIT

echo "${GREEN}Cloning Spyglass...${NC}"
if ! git clone "https://github.com/uncle-alek/Spyglass.git" > /dev/null 2>&1
then
    echo "${RED}Failed to clone Spyglass!${NC}"
    exit 1
fi

pushd "./Spyglass" > /dev/null 2>&1

echo "${GREEN}Building Spyglass...${NC}"
if ! xcodebuild -project Spyglass.xcodeproj -scheme Spyglass -derivedDataPath ./build -configuration Release > /dev/null 2>&1
then
    echo "${RED}Failed to build Spyglass!${NC}"
    exit 1
fi

echo "${GREEN}Moving Spyglass to Application folder...${NC}"
if ! cp -R ./build/Build/Products/Release/Spyglass.app /Applications > /dev/null 2>&1
then
    echo "${RED}Failed to move Spyglass to Application folder!${NC}"
    exit 1
fi

popd > /dev/null 2>&1
rm -rf "./Spyglass"

echo "${BGREEN}Congratulations, Spyglass has been successfully installed on your computer!!!${NC}"
