#!/usr/bin/env bash

# ----------------------------------
#-COLORZ-
# ----------------------------------
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

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

#~CHECK IF YOU ARE CONNECTED TO THE WORLD~
echo " "
wget -q --spider http://google.com

if
  [ $? -eq 0 ]
then
  printf "${GREEN}Ok, you are online, lets begin.${NOCOLOR}"
else
  printf "${RED}Seem like you are offline, i cannot pong google.com.${NOCOLOR}"
fi

#~USER AGREEDMENT~
echo " "
read -p 'This script will install, set and deploy CulhwchFarm. To continue press y/n (to not): ' agree

if
  [ "$agree" == "y" ]; then
  echo 'Lets begin then.'
  echo 'Lets install all req'
  echo " "

#~OS CHECK~
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Error: /etc/os-release not found. Unable to determine the OS."
    exit 1
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
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac
elif
  [ "$agree" == "n" ]; then
  echo 'Bye then.'
  exit
else
  echo 'Ha-ha, you soo funny...'
exit
fi

#~FUNCTION FOR EXISTENSE~
exists()
{
  command -v "$1" >/dev/null 2>&1
}

#~FUNCTION FOR RANDOM PASS~
array=()
while [[ ${#array[@]} -lt 12 ]]; do
    random_char=$(printf \\$(printf '%03o' $((RANDOM%26+65))))
    array+=( $random_char )
done

output=$(printf "%s" "${array[@]}") > /dev/null
RANDOM_NO_SPACE=${output// /}

#~INSTALLIG FARM N CHECKING FOR GIT~
echo " "
read -p 'Checking for git, if it installed. If not, i will install it for you - y/n: ' lzt

if
  [ "$lzt" == "n" ]
then
  echo 'Fuck you then.'
  exit
fi

if
  exists git && [ "$lzt" == "y" ]; then
  printf "${GREEN}Git found!${NOCOLOR}"
else
  ! exists git
  printf "${RED}Git not found.${NOLOCOR} Installing."
  apt install git -y 2>/dev/null &
pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}" " "
  sleep .1
done

  printf "${GREEN}Successful!${NOCOLOR}"
  echo " "
  echo 'Now you have git.'
fi

echo " "
read -p 'Git was found/install, so im ready to install CulhwchFarm, are you ready - y/n: ' git

if
  [ "$git" == "y" ]
then
  git clone --recurse-submodules https://github.com/arkiix/CulhwchFarm.git 2>/dev/null &
pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}" " "
  sleep .1
done

printf "${GREEN}Successful!${NOCOLOR}"
echo " "

  cd CulhwchFarm
elif
  [ "$git" == "n" ]
then
  echo 'What do you want from me then, kutabare.'
  exit
else
  echo 'fuck you.'
  exit
fi

#~SETTING UP FARM~
echo " "
read -p 'Ok, we are ready to change your default dashboard pass, cawabanga - y/n: ' cawabanga

if
  [ "$cawabanga" == "y" ]
then
  NEWPASS=$(echo "${RANDOM_NO_SPACE}") && sed -i "/environment:/,/^\w/{s/SERVER_PASSWORD: '893'/SERVER_PASSWORD: '$NEWPASS'/}" compose.yml
  printf "${GREEN}Uuh, well, thats it, done.${NOCOLOR}"
elif
  [ "$cawabanga" == "n" ]
then
  echo 'There is need to be y, but you pick n, fuck you, uwu.'
else
  echo 'fuck you.'
  exit
fi

#~DEPLOYING FARM~
echo " "
read -p 'Checking for docker, if it installed. If not, i will install it for you - y/n: ' docker

if
  [ "$docker" == "n" ]
then
  echo 'Fuck you then.'
  exit
fi

echo " "

if
  exists docker && [ "$docker" == "y" ]; then
  printf "${GREEN}Docker found!${NOCOLOR}"
  echo " "
else
  ! exists
  printf "${RED}Docker not found.${NOCOLOR} Installing."
  echo " "
    apt install docker -y 2>/dev/null &
pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}" " "
  sleep .1
done

printf "${GREEN}Successful!${NOCOLOR}"
echo " "

echo " "
echo 'Now you have docker.'
fi

read -p 'Checking for docker-compose, if it installed. If not, i will install it for you - y/n: ' lztt

if
  [ "$lztt" == "n" ]
then
  echo 'Fuck you then.'
  exit
fi

echo " "

if
  exists docker-compose && [ "$lztt" == "y" ]; then
  printf "${GREEN}Docker-compose found!${NOCOLOR}"
else
  ! exists
  printf "${RED}Docker-compose not found.${NOCOLOR} Installing."
  echo " "
  apt install docker-compose -y 2>/dev/null &
pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}" " "
  sleep .1
done

printf "${GREEN}Successful!${NOCOLOR}"
echo " "

  echo " "
  echo 'Now you have docker-compose.'
fi


echo " "
read -p 'Finally. Now we can deploy your farm and start explode a/d with flags from your exploits! Make some noise - y/n: ' noise

if
  [ "$noise" == "y" ]
then
  sudo docker-compose up --build -d
  echo " "
  echo 'Farm now running in background, to stop it, type: docker-compose down.'
  echo " "
  echo "

  +-----------------------------------+
  |        FARM IS RUNNING ON         |
  +-----------------------------------+
                  
            http://vuln:8893

  +-----------------------------------+
  |         FARM CREDENTIALS          |
  +-----------------------------------+
                                      
         "${RANDOM_NO_SPACE}"
                                      
  +-----------------------------------+
                                          "
elif
  [ "$noise" == "n" ]
then
  echo 'As you want, cap.'
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
echo 'Thanks for using me, take care and good luck ^v^'
echo 'by yuyu from 893crew'
