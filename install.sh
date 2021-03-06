#/bin/sh

# OhMySh

# config
OMS="$HOME/.ohmysh"
OMS_CACHE="$HOME/.ohmysh-cache"
OMS_RC="#
# CREATED BY OhMySh <https://github.com/ohmysh/ohmysh>
# OhMySh
#

# OhMySh work dir. Please don't edit it!
OMS_DIR='$OMS'
OMS_CACHE='$OMS_CACHE'

# OhMySh theme
OMS_THEME='colorshell'
OMS_PLUGIN=(helloworld)

# OhMySh main script
source \"\$OMS_DIR/main.sh\"

# Global defines
# Such as 'alias XXXX=\"XXXX\"'
"
OMS_RC_D="$HOME/.profile"
NF="NEWFILE"

if [ -f "$HOME/.ohmysh-backup" ]
then
  NF="OLDFILE"
  mv "$HOME/.ohmysh-backup" "$OMS_RC_D"
  . $OMS_RC_D
  $OMS=$OMS_DIR
fi  

# lib
checkcommand(){
  if [ -n $2  ]; then
    where="::$2"
  fi
  hash $1 2>/dev/null || { echo " >> OhMySh$where : ERROR cannot found command \"$1\", please insall it!!! "; return 1; }
 return 0
}

omsconfig(){
  cat <<EOF > "$OMS_RC_D"
#
# CREATED BY OhMySh <https://github.com/ohmysh/ohmysh>
# OhMySh
#
# OhMySh work dir. Please don't edit it!
OMS_DIR='$OMS'
OMS_CACHE='$OMS_CACHE'

# OhMySh theme
OMS_THEME='colorshell'
OMS_PLUGIN=(helloworld)

# OhMySh main script
source "\$OMS_DIR/main.sh"

EOF
}

echo ' Welcome to OhMySh installer script! '
echo '   OhMySh <https://github.com/ohmysh/ohmysh>'

# options
if [ ! -z "$1" ]
then
  if [ "$1" = "--config" ]
  then
    echo ' >> Config Force'
    omsconfig
  else
    cat <<EOF
Installer Help --- OhMySh
[OPTIONS]
    --help      :   Get help
    --config    :   Config only
OhMySh Installer Script
EOF
  fi
  exit
fi

# install
echo ' >> Preparing Install'
checkcommand git Installer
if [ $? == 1 ] ; then
  echo ' >> [ERROR 1] OhMySh::Installer : ERROR Failed to install OhMySh!!! '
  exit 1
fi
if [ -d "$OMS" ]
then
  echo ' >> [ERROR 2] OhMySh::Installer : You had installed OhMySh!!! '
fi
echo ' >> Getting OMS'
git clone https://github.com/ohmysh/ohmysh.git "$OMS"
echo ' >> Putting config file'
if [ "$NF" = "NEWFILE" ] ; then
  omsconfig
fi
echo ' >> Creating cache'
mkdir -p "$OMS_CACHE"
date +%Y%m%d > $OMS_CACHE/update
cp "$OMS/lib/alias.e.sh" "$OMS_CACHE/alias.ohmysh.sh"

echo ' OhMySh is already installed! '

# config
echo ' Configing... '
echo ' >> Checking shell'
if [ $SHELL != "/bin/sh" ] ; then
  echo '    -> Do you want to change shell to "sh"? It will work with OhMySh (Y/N)'
  read ch
  if [ "$ch" = 'Y' ] || [ "$ch" = 'y' ] ; then
    echo '    -> Change shell to "sh" '
    chsh -s /bin/sh || echo '    -> Change ERROR!!! Try to run "chsh -s /bin/sh" when script exit'
  else
    echo '    -> You chose NO'
  fi
fi

source "$OMS/lib/ohmysh-version.sh"
echo " Installed OhMySh Version $OMS_VER!"

# OhMySh Installer Script.

