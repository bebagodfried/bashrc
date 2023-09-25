#!/bin/bash
# 
# Name: bashrc man - (main)
# Description: Tool set commands for GNU Bash script
# Copyright (C) 2023 - Beba Godfried.
# This program may be freely redistributed under the terms of the GNU GPL
#

# Format
Y='\033[0;33m'  # color: brown
R='\033[0;31m'  # color: red
G='\033[0;32m'  # color: green

B='\033[1m'     # font: 600
A='\033[0m'     # automatic (reset)
clear

# initialization
# - command-line arguments
append_2shell=$2
append_2paths=$2

# - define .bashrc location
bashrc=~/.bashrc

echo -e "${Y}${B}[ bashrc 1.0 by @bebagodfried - GitHub ]${A}${A}"

# functions
# - completed: return success
completed() {
  echo -e "${G}Completed!${A} - Type ${B}\`source ~/.bashrc\`${A} or ${B}\`bash\`${A} to load the new \`.bashrc\`"
}

# - Set timeout
timeout() {
  timer=$1

  completed
  if [[ $timer != '' && $timer != 0 ]];then
    read -t $timer esc
    
  else
    read esc
  fi

  echo ''
}

# Create a buckup => to .bashrc_origin
# Create a buckup => to .bashrc_backup

if [[ ! -e ~/.bashrc_origin ]];then
  # Built-in .bashrc backup (origin)
  cat $bashrc >> ~/.bashrc_origin
fi

if [[ $1 != "--undo" && $1 != "-u" && $1 != "--show" && $1 != "-s" && $1 != "--help" && $1 != "-h" &&  $1 != "--origin" && $1 != "-o" ]];then
  # Copy of current .bashrc (backup)
  cat $bashrc > ~/.bashrc_backup
fi

# `bashrc` command
if ! command -v bashrc >> /dev/null;then
  echo "export PATH=$PATH:$PWD" >> $bashrc
  echo -e "${G}Initialize \`$PWD\` - Ok!${A}"
  timeout 0
fi

# Shell reload
source $bashrc

# Shell
key=$1
arg=$2
if   [[ $key == "--insert" || $key == "-i" ]];then
  # Append a rule to bashrc/shell
  echo "$append_2shell" >> $bashrc

elif [[ $key == "--export" || $key == "-e" ]];then
  # Append a rules to `.bashrc`
  echo "export PATH=$PATH:$append_2paths" >> $bashrc
  timeout 3

elif [[ $key == "--alias" || $key == "-a" ]];then
  # Define alias
  echo "alias $arg" >> $bashrc
  timeout 3

elif [[ $key == "--show" || $key == "-s" ]];then
  clear
  # Display `bashrc`
  cat $bashrc && echo ''

elif [[ $key == "--reload" || $key == "-r" ]];then
  # Load the last modification
  source $bashrc

elif [[ $key == "--edit" ]];then
  # edit the currently configured
  xdg-open $bashrc

elif [[ $key == "--undo" || $key == "-u" ]];then
  # Reload your last working backup
  diff $bashrc ~/.bashrc_backup >> /dev/null

  if [[ $? == 1 ]];then
    > $bashrc
    cat ~/.bashrc_backup > $bashrc
    timeout 3

  else
    # Reload the internal backup
    diff $bashrc ~/.bashrc_origin >> /dev/null

    if [[ $? == 1 ]];then
      cat ~/.bashrc_origin > $bashrc
      timeout 3

    else

      echo "${R}No backup available!${A}"
      exit 1
    fi
  fi

elif [[ $key == "--0" || $key == "-o" ]];then
  # Reload the original backup
  cat ~/.bashrc_origin > $bashrc
  
elif [[ $key == "--help" || $key == "-h" || $key == "" ]];then
  # Help
  clear
  echo -e "${Y}${B}[ bashrc 1.0 by @bebagodfried - GitHub ]${A}${A}"
  echo -e "$ ${B}Usage:${A} bashrc [OPTION] [ARG]"
  echo "$ Manage your GNU Bash shell script whenever it is run/started interactively."
  echo ""
  echo -e "  -a, ${B}--alias${A}         define a simple aliases to commands"
  echo -e "  -i, ${B}--insert${A}        customizing the terminal session"
  echo -e "  -e, ${B}--export${A}        make exported shell variables ‘permanent’"
  echo -e "  -s, ${B}--show  ${A}        view the currently configured \`.bashrc\`"
  echo -e "  -r, ${B}--reload${A}        restart and load shell variables"
  echo -e "  -u, ${B}--undo  ${A}        restore the last shell backup"
  echo -e "  -o, ${B}--reset ${A}        restore the internal shell script"
  echo -e "  -h, ${B}--help  ${A}        display this help and exit"
  echo -e "      ${B}--edit  ${A}        edit the currently configured \`.bashrc\`"
  # echo ""

  read esc
  clear
else
  # Help
  clear
  echo -e "${Y}${B}[ bashrc 1.0 by @bebagodfried - GitHub ]${A}${A}"
  echo -e "${R}${B}error:${A}${A} unrecognized option '$key'"
  echo -e "Try ${B}'bashrc --help'${A} for more information."
  echo ""

  read esc
  clear
fi