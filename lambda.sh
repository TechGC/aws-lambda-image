#!/usr/bin/env bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

# Smart workdir handling :)
root_directory=`git rev-parse --show-toplevel 2>/dev/null`
if [ -z $root_directory"" ] ; then
  echo -e "\nYou are not in a repo root directory."
  echo -e "Please cd into it and run this script again."
  echo -e "Aborting...\n"
  exit 1
fi

if [ ! `pwd` == $root_directory ] ; then
  echo -e "\nChanging to root directory: $root_directory"
  cd $root_directory
fi

show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    GREEN_TEXT=`echo "\033[32m"`
    ENTER_LINE=`echo "\033[33m"`
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${GREEN_TEXT}Choose Lambda configuration target:${NORMAL}\n"
    echo -e "${MENU}**${NUMBER} 1)${MENU} techgc-public/content-library-admin-dev ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} techgc-public/content-library-admin-prod ${NORMAL}"
    echo -e "\n${MENU}**${NUMBER} 0)${MENU} Clean up bundle files & node_modules. ${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
    read opt
}
function option_picked() {
    COLOR='\033[01;32m' # bold green
    RESET='\033[00;00m' # normal white
#    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "Uploading Lambda code for ${COLOR}${MESSAGE}${RESET}"
}

clear
show_menu
while [ opt != '' ]
    do
      if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
           option_picked "techgc-public/content-library-admin-dev";
           make TARGET=content_library_admin_dev FUNCTION=devContentLibraryAdminConverter configtest && \
           make TARGET=content_library_admin_dev FUNCTION=devContentLibraryAdminConverter uploadlambda;
           exit;
           ;;

        2) clear;
           option_picked "techgc-public/content-library-admin-prod";
           make TARGET=content_library_admin_prod FUNCTION=prodContentLibraryAdminConverter configtest && \
           make TARGET=content_library_admin_prod FUNCTION=prodContentLibraryAdminConverter uploadlambda;
           exit;
            ;;

        0) clear;
           make clean;
           exit;
            ;;

        x)exit;
        ;;

        q)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
          echo -e "${RED_TEXT}Pick an option from menu!${NORMAL}\n";
          show_menu;
        ;;
    esac
fi
done
