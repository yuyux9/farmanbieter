#!/usr/bin/env bash

#~WELCOME MESSAGE~
cat << "EOF"
                                                                                       ..       .                    s                            
   oec :                                                                         . uW8"        @88>                 :8                            
  @88888                 .u    .      ..    .     :                   u.    u.   `t888         %8P                 .88                  .u    .   
  8"*88%        u      .d88B :@8c   .888: x888  x888.        u      x@88k u@88c.  8888   .      .         .u      :888ooo      .u     .d88B :@8c  
  8b.        us888u.  ="8888f8888r ~`8888~'888X`?888f`    us888u.  ^"8888""8888"  9888.z88N   .@88u    ud8888.  -*8888888   ud8888.  ="8888f8888r 
 u888888> .@88 "8888"   4888>'88"    X888  888X '888>  .@88 "8888"   8888  888R   9888  888E ''888E` :888'8888.   8888    :888'8888.   4888>'88"  
  8888R   9888  9888    4888> '      X888  888X '888>  9888  9888    8888  888R   9888  888E   888E  d888 '88%"   8888    d888 '88%"   4888> '    
  8888P   9888  9888    4888>        X888  888X '888>  9888  9888    8888  888R   9888  888E   888E  8888.+"      8888    8888.+"      4888>      
  *888>   9888  9888   .d888L .+     X888  888X '888>  9888  9888    8888  888R   9888  888E   888E  8888L       .8888Lu= 8888L       .d888L .+   
  4888    9888  9888   ^"8888*"     "*88%""*88" '888!` 9888  9888   "*88*" 8888" .8888  888"   888&  '8888c. .+  ^%888*   '8888c. .+  ^"8888*"    
  '888    "888*""888"     "Y"         `~    "    `"`   "888*""888"    ""   'Y"    `%888*%"     R888"  "88888%      'Y"     "88888%       "Y"      
   88R     ^Y"   ^Y'                                    ^Y"   ^Y'                    "`         ""      "YP'                 "YP'                 
   88>                                                                                                                                            
   48                                                                                                                                             
   '8                                                                                                                                         
    "                                                                                                                                        
                                                                     [yuyu]
                                                                   [893crew~]

EOF

#~INSTALL GUM~
echo " "
if ! command -v gum &> /dev/null; then
    echo "gum not found, installing gum..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install -y gum
    if ! command -v gum &> /dev/null; then
        gum style --foreground 1 "Failed to install gum. Please install it manually."
        exit 1
    fi
    gum style --foreground 2 "gum installed successfully."
fi

#~CHECK IF YOU ARE CONNECTED TO THE WORLD~
echo " "
if wget -q --spider http://google.com; then
    gum style --foreground 2 --bold --margin "1" "Ok, you are online, let's begin."
else
    gum style --foreground 1 --bold --margin "1" "Seems like you are offline, I cannot ping google.com."
    exit 1
fi

#~USER AGREEDMENT~
echo " "
if ! gum confirm "This script will install, set, and deploy CulhwchFarm. Do you want to continue?"; then
    gum style --foreground 1 "User declined. Exiting..."
    exit 1
fi
  echo " "

#~OS CHECK~
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    gum style --foreground 1 "Error: /etc/os-release not found. Unable to determine the OS."
    if ! gum confirm "Unable to determine the OS. Do you want to continue anyway?"; then
        gum style --foreground 1 "Exiting due to inability to determine OS."
        exit 1
    fi
    OS="unknown"
fi

case $OS in
    "ubuntu")
        apt install ca-certificates curl gnupg lsb-release -y
        mkdir /etc/apt/demokeyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/demokeyrings/demodocker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/demokeyrings/demodocker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
        apt update -y
        apt install docker-ce docker-ce-cli containerd.io -y
        # Docker-compose is installed separately for Ubuntu
        curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        ;;

    "centos")
        yum install -y epel-release
        yum install -y ca-certificates curl gnupg lsb-release
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum install docker-ce docker-ce-cli containerd.io -y
        systemctl start docker
        systemctl enable docker
        ;;


    "debian")
        apt-get install ca-certificates curl gnupg lsb-release -y
        mkdir /etc/apt/demokeyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/demokeyrings/demodocker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/demokeyrings/demodocker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
        apt-get update -y
        apt-get install docker-ce docker-ce-cli containerd.io -y
        # Docker-compose is installed separately for Ubuntu
        curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        ;;

    *)
        gum style --foreground 1 "Unsupported OS: $OS"
        if ! gum confirm "Your OS is not officially supported. Do you want to continue anyway?"; then
            gum style --foreground 1 "Exiting due to unsupported OS."
            exit 1
        fi
        ;;
esac

#~INSTALLIG FARM N CHECKING FOR GIT~
echo " "
if ! command -v git &> /dev/null; then
    gum spin --spinner dot --title "Installing Git" -- apt install git -y
    gum style --foreground 2 "Git successfully installed!"
else
    gum style --foreground 2 "Git is already installed!"
fi

echo " "
if gum confirm "Git is ready. Do you want to clone and set up CulhwchFarm?"; then
    git clone --recurse-submodules https://github.com/arkiix/CulhwchFarm.git
    gum style --foreground 2 "CulhwchFarm repository cloned successfully!"
    cd CulhwchFarm
else
    gum style --foreground 1 "What do you want from me then, kutabare..."
    exit 1
fi
echo " "

#~SETTING UP FARM~
echo " "
if gum confirm "Ready to change your default dashboard password?"; then
    NEWPASS=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12)
    sed -i "/environment:/,/^\w/{s/SERVER_PASSWORD: '893'/SERVER_PASSWORD: '$NEWPASS'/}" compose.yml
    gum style --foreground 2 "Password updated successfully!"
else
    gum style --foreground 1 "There is need to be y, but you pick n, fuck you, uwu."
fi

#~DEPLOYING FARM~
echo " "
if ! command -v docker &> /dev/null; then
    gum spin --spinner dot --title "Installing Docker" -- apt install docker -y
    gum style --foreground 2 "Docker successfully installed!"
else
    gum style --foreground 2 "Docker is already installed!"
fi

if ! command -v docker-compose &> /dev/null; then
    gum spin --spinner dot --title "Installing Docker Compose" -- apt install docker-compose -y
    gum style --foreground 2 "Docker Compose successfully installed!"
else
    gum style --foreground 2 "Docker Compose is already installed!"
fi

echo " "
if gum confirm "Finally, do you want to deploy your farm?"; then
    sudo docker-compose up --build -d
    gum style --foreground 2 --border double --border-foreground 3 --margin "1" --padding "1" \
    "FARM IS RUNNING ON - http://vuln:8893 & FARM CREDENTIALS - ${NEWPASS}"
else
    gum style --foreground 1 "Deployment canceled by looser."
fi

echo " "
echo "

⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⣖⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣾⡟⣉⣽⣿⢿⡿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢠⣿⣿⣿⡗⠋⠙⡿⣷⢌⣿⣿⠀⠀⠀⠀⠀⠀⠀
⣷⣄⣀⣿⣿⣿⣿⣷⣦⣤⣾⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀
⠈⠙⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⢀⠀⠀⠀⠀
⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠻⠿⠿⠋⠀⠀⠀⠀
⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⡄
⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⢀⡾⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣷⣶⣴⣾⠏⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠋⠁⠀⠀⠀
                          "
gum style --foreground 6 --bold --align center "Thanks for using me, take care and good luck ^v^"
gum style --foreground 6 --bold --align center "by yuyu from 893crew"
