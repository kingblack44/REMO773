#!/data/data/com.termux/files/usr/bin/bash
MSF () {
cat > $PREFIX/bin/msfconsole <<- EOF
#!/data/data/com.termux/files/usr/bin/bash

SCRIPT_NAME=$(basename "$0")
METASPLOIT_PATH="${HOME}/metasploit-framework"
# Fix ruby bigdecimal extensions linking error.
case "$(uname -m)" in
	aarch64)
		export LD_PRELOAD="${PREFIX}/lib/ruby/2.6.0/aarch64-linux-android/bigdecimal.so:$LD_PRELOAD"
		;;
	arm*)
		export LD_PRELOAD="${PREFIX}/lib/ruby/2.6.0/arm-linux-androideabi/bigdecimal.so:$LD_PRELOAD"
		;;
	i686)
		export LD_PRELOAD="${PREFIX}/lib/ruby/2.6.0/i686-linux-android/bigdecimal.so:$LD_PRELOAD"
		;;
	x86_64)
		export LD_PRELOAD="${PREFIX}/lib/ruby/2.6.0/x86_64-linux-android/bigdecimal.so:$LD_PRELOAD"
		;;
	*)
		;;
esac
pg_ctl --log=$HOME/.log_msf -D $PREFIX/var/lib/postgresql restart &> /dev/null;
case "$SCRIPT_NAME" in
	msfconsole|msfvenom)
		exec ruby "$METASPLOIT_PATH/$SCRIPT_NAME" "$@"
		;;
	*)
		echo "[!] Unknown Metasploit command '$SCRIPT_NAME'."
		exit 1
		;;
esac
EOF
}

cwd=$(pwd)
#name=$(basename "$0")
#export msfinst="$cwd/$name"
#sha_actual=$(sha256sum $(echo $msfinst))
#echo $sha_actual
#if [ $name != "metasploit.sh" ]; then
#	echo "[-] Please do not use third-party stolen scripts"
#	exit 1
#fi

msfvar=5.0.4
msfpath='/data/data/com.termux/files/home'
if [ -d "$msfpath/metasploit-framework" ]; then
	echo "deleting old version..."
        rm $msfpath/metasploit-framework -rf
fi
apt update
apt install -y ncurses-utils autoconf bison clang coreutils finch curl findutils git apr apr-util libffi-dev libgmp-dev libpcap-dev postgresql-dev readline-dev libsqlite-dev openssl-dev libtool libxml2-dev libxslt-dev ncurses-dev pkg-config wget make ruby-dev libgrpc-dev termux-tools ncurses-utils ncurses unzip zip tar postgresql termux-elf-cleaner

cd $msfpath
curl -LO https://github.com/rapid7/metasploit-framework/archive/$msfvar.tar.gz
tar -xf $msfpath/$msfvar.tar.gz
mv $msfpath/metasploit-framework-$msfvar $msfpath/metasploit-framework
cd $msfpath/metasploit-framework
gem install bundler
#--version=1.17.3 -- --use-system-libraries

#gem install bigdecimal
gem install pg --version=0.20.0 -- --use-system-libraries
gem install nokogiri -v'1.8.5' -- --use-system-libraries
cd $msfpath/metasploit-framework
gem update --system
bundle install -j5





echo -e "\033[34mGems installed\033[0m"
$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;

if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi
if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi

MSF
chmod +rwx $PREFIX/bin/msfconsole
ln -sf $(which msfconsole) $PREFIX/bin/msfvenom

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

echo "$(tput setaf 3)you can directly use $(tput setaf 1)msfvenom$(tput setaf 3) or $(tput setaf 1)msfconsole $(tput setaf 3)rather than $(tput setaf 2)./msfvenom or ./msfconsole$(tput setaf 3) as they are $(tput setaf 1)symlinked to $PREFIX/bin$(tput sgr0)"
