#!/data/data/com.termux/files/usr/bin/bash
#here is proxychains-ng for termux
clear
echo -e "\x1B[01;94m ────────────╔╗───╔╗──╔═╗ \x1B[0m"
echo -e "\x1B[01;94m ╔═╦╦╦═╦╦╦╦╦═╣╚╦═╗╠╬═╦╣═╣╔══╗╔═╦╦═╗ \x1B[0m"
echo -e "\x1B[01;94m ║╬║╔╣╬╠║╣║║═╣║║╬╚╣║║║╠═║╚══╝║║║║╬║ \x1B[0m"
echo -e "\x1B[01;94m ╚╝──────╚═╝────────────────────╚═╝ \x1B[0m"
sleep 5
echo -e "\\033[48;5;95;38;5;214m### update and upgrade ###\\033[0m"
sleep 5
apt update && apt upgrade -y
clear
# need some packages....
echo -e "\\033[48;5;95;38;5;214m### some packages need to install install ###\\033[0m"
sleep 5
apt install nginx pv make ncurses-utils coreutils -y
clear
echo "$(tput bold)$(tput setaf 3)Extracting tar package...$(tput sgr 0)" | pv -qL 8 ;
sleep 5
tar xzf proxychains-ng-4.12.tar.gz
mv proxychains-ng-4.12 $HOME/
cd $HOME/proxychains-ng-4.12
chmod 777 configure
clear
echo "$(tput bold)$(tput setaf 3)Setup configuration.....$(tput sgr 0)" | pv -qL 8 ;
echo -e "\\033[48;5;95;38;5;214m### So plz wait... ###\\033[0m"
sleep 5
./configure
make && make install
clear
echo -e "\\033[48;5;95;38;5;214m### setup finish.. ###\\033[0m"
sleep 5
proxychains4
echo "$(tput bold)$(tput setaf 3)now  typ command $(tput setaf 1)proxychains4$(tput setaf 3) for proxychains setup like Kali Linux..$(tput sgr 0)" | pv -qL 8 ;
