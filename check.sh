#!/bin/bash

# Color codes
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for essential build tools
echo -e "* Checking for essential build tools..."
which gcc &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] gcc not found. Please install build-essential package."; exit 1; }

# Check gcc version
gcc_version=$(gcc --version | awk '/gcc/ {print $3}')
echo -e "* Found gcc version: $gcc_version [ ${PURPLE}OK${NC} ]"

# Check if gcc version is not newer than 13
if [[ "$gcc_version" > "13" ]]; then
  echo -e "[ ${RED}!!${NC} ] Error: gcc version $gcc_version is newer than version 13. Please install a compatible version."
  exit 1
fi

which make &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] make not found. Please install build-essential package."; exit 1; }
which wget &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] wget not found. Please install wget."; exit 1; }
which tar &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] tar not found. Please install tar."; exit 1; }
which gzip &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] gzip not found. Please install gzip."; exit 1; }
which bzip2 &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] bzip2 not found. Please install bzip2."; exit 1; }
which cpio &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] cpio not found. Please install cpio."; exit 1; }

# Check for libraries required by the kernel
echo -e "* Checking for libraries required by the kernel..."
sudo apt-get install -y libncurses5-dev &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] Failed to install libncurses5-dev."; exit 1; }
sudo apt-get install -y flex &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] Failed to install flex."; exit 1; }
sudo apt-get install -y bison &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] Failed to install bison."; exit 1; }

# Check for libraries required by BusyBox
echo -e "* Checking for libraries required by BusyBox..."
sudo apt-get install -y libncurses5-dev &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] Failed to install libncurses5-dev."; exit 1; }
sudo apt-get install -y libssl-dev &>/dev/null && echo -e "[ ${PURPLE}OK${NC} ]" || { echo -e "[ ${RED}!!${NC} ] Failed to install libssl-dev."; exit 1; }

echo -e "* All required libraries and tools are installed! [ ${GREEN}OK${NC} ]"
