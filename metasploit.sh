#!/data/data/com.termux/files/usr/bin/bash

cwd=$(pwd)
#name=$(basename "$0")
#export msfinst="$cwd/$name"
#sha_actual=$(sha256sum $(echo $msfinst))
#echo $sha_actual
#if [ $name != "metasploit.sh" ]; then
#	echo "[-] Please do not use third-party stolen scripts"
#	exit 1
#fi

msfvar=5.0.19
msfpath='/data/data/com.termux/files/home'
if [ -d "$msfpath/metasploit-framework" ]; then
	echo "deleting old version..."
        rm $msfpath/metasploit-framework -rf
fi
apt update && apt upgrade -y
apt install -y ncurses-utils autoconf bison clang coreutils finch curl findutils git apr apr-util libffi-dev libgmp-dev libpcap-dev postgresql-dev readline-dev libsqlite-dev openssl-dev libtool libxml2-dev libxslt-dev ncurses-dev pkg-config wget make ruby-dev libgrpc-dev termux-tools ncurses-utils ncurses unzip zip tar postgresql termux-elf-cleaner

cd $msfpath
curl -LO https://github.com/rapid7/metasploit-framework/archive/$msfvar.tar.gz
tar -xf $msfpath/$msfvar.tar.gz
mv $msfpath/metasploit-framework-$msfvar $msfpath/metasploit-framework
cd $msfpath/metasploit-framework
gem install bundler --version=1.17.3 -- --use-system-libraries

#gem install bigdecimal
gem install pg --version=0.20.0 -- --use-system-libraries
gem install nokogiri -v'1.10.2' -- --use-system-libraries
gem install nokogiri -v'1.8.5' -- --use-system-libraries
cd $msfpath/metasploit-framework
gem update --system
#gem install bundler --version "1.17.3"
bundle install -j5





echo -e "\033[34mGems installed\033[0m"
$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;

if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi
if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi
curl https://raw.githubusercontent.com/remo7777/REMO773/master/msfconsole | cat >> $PREFIX/bin/msfconsole
#curl https://transfer.sh/Fu432/msfconsole3.txt | cat >> $PREFIX/bin/msfconsole
chmod +rwx $PREFIX/bin/msfconsole
ln -sf $(which msfconsole) $PREFIX/bin/msfvenom
#rm /data/data/com.termux/files/usr/lib/ruby/2.6.0/bigdecimal.rb
#curl https://raw.githubusercontent.com/remo7777/REMO773/master/bigdecimal.rb | cat >> /data/data/com.termux/files/usr/lib/ruby/2.6.0/bigdecimal.rb
sed -i "s/warn/#warn/g" $LD_LIBRARY_PATH/ruby/2.6.0/bigdecimal.rb

#chmod +rwx $PREFIX/bin/msfvenom

termux-elf-cleaner /data/data/com.termux/files/usr/lib/ruby/gems/2.6.0/gems/pg-0.20.0/lib/pg_ext.so

echo "Creating database"

cd $msfpath/metasploit-framework/config

curl -LO https://Auxilus.github.io/database.yml

mkdir -p $PREFIX/var/lib/postgresql

initdb $PREFIX/var/lib/postgresql

pg_ctl -D $PREFIX/var/lib/postgresql start

createuser msf

createdb msf_database

rm $msfpath/$msfvar.tar.gz
cd $HOME
#curl https://transfer.sh/OVIM/fix-ruby-bigdecimal.sh | bash

echo "$(tput setaf 3)you can directly use $(tput setaf 1)./msfvenom$(tput setaf 3) or $(tput setaf 1)./msfconsole $(tput setaf 3)rather than $(tput setaf 2)msfvenom or msfconsole$(tput setaf 3) as they are $(tput setaf 1)symlinked to $PREFIX/bin$(tput sgr0)"
