
#! /bin/bash
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help                                       show brief help"
      echo "-p, --proxy                                        specify proxy"
      echo "-o, --os            specify operating system as centos or fedora\n"
      exit 0
      ;;
    -p|--proxy)
      shift
       if test $# -gt 0; then
         url_regex='(http|https|ftp|file)://[-A-Za-z0-9\+\-&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+\-&@#/%=~_|]'
         if [[ $1 =~ $url_regex ]]
         then
          export PROXY=$1
          sudo echo "proxy=$PROXY" >> /etc/yum.conf
          sudo -E HOME=$HOME sh -c 'echo -e "use_proxy=yes\nhttps_proxy=$PROXY\nhttp_proxy=$PROXY" > $HOME/.wgetrc'
          echo "current proxy is: $PROXY\n"
         else
          echo "provided proxy is not valid\n"
          exit 1
         fi
       else
         echo "no proxy specified\n"
         exit 1
       fi
      shift
      ;;
    -o|--os)
     shift
      if [[ $1 == 'centos' ]]
      then
       echo $1
       package_manager="yum"
      else
       if [[ $1 == 'fedora' ]]
       then
        package_manager="dnf"
       else
        echo "this script only supports Fedora/Centos"
        echo "please specify operating system with -o flag\n"
        exit 1
       fi
      fi
     shift
     ;;
    -e|--env)
     shift
      if [[ $1 == 'work' || $1 == 'home' ]]
      then
       ENV=$1
      else
       echo "environment should be work or home\n"
       exit 1
      fi
     shift
     ;;
    *)
      break
      ;;
  esac
done

if [[ $(whoami) == 'root' ]]
then
 echo "run the script as non-root\n"
 exit 1
fi

if [[ $package_manager == "" ]]
then
 echo "please specify operating system with -o flag"
 exit 1
fi

echo "Updating system"
sudo $package_manager update -y

echo "Installing git\n"
$package_manager install -y git

echo "Configuring git\n"
if [[ $ENV == 'work' ]]
then
 git_email='cagatay.tanyildiz@nokia.com'
 git_user='ctanyild'
 git config --global core.editor "vim"
else
 if [[ $ENV == 'home' ]]
 then
  git_email='cagatay@cagataytanyildiz.com'
  git_user='cagta'
  git config --global core.editor "code --wait"
 else
  echo "git configuration failed. environment should be work or home\n"
  exit 1
 fi
fi

git config --global commit.verbose true
git config --global user.name $git_user
git config --global user.email $git_email

echo "Installing zsh\n"
sudo $package_manager install -y zsh
echo "Installing oh my zsh\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "Copying oh my zsh configs\n"
cp zshrc_template $HOME/.zshrc
sed -i "s|HOME_PATH|$HOME|g" $HOME/.zshrc
echo "Installing docker\n"
sudo $package_manager install -y docker
echo "Docker post-installation steps are running\n"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable docker

if [[ $ENV == 'home' ]]
then
 echo "Adding VSCode's repository and key\n"
 sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
 sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
 sudo $package_manager update -y
 echo "Installing VSCode\n"
 sudo $package_manager install -y code
 echo "Installing tmux\n"
 sudo $package_manager install -y tmux
 echo "Adding Oracle Virtualbox's repository and key\n"
 sudo rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
 sudo sh -c 'echo -e "[code]\nname=VirtualBox\nbaseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/29/x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://www.virtualbox.org/download/oracle_vbox.asc" > /etc/yum.repos.d/vscode.repo'
 echo "Installing Oracle Virtualbox\n"
 sudo $package_manager install -y virtualbox
 echo "Installing Filezilla\n"
 sudo $package_manager install -y filezilla
 echo "Installing GIMP\n"
 sudo $package_manager install -y gimp
 echo "Installing Chromium"
 sudo $package_manager install -y chromium
fi