# bootstrap script for provisioning my dev environment on a virtual machine
# running Arch

# update all packages
sudo pacman -Syu --noconfirm

# install things I want

mypackages=$(
  git
  htop
  vim
  weechat
  wget
  xterm
  xorg-server
  xorg-xinit
  xorg-server-utils
  mesa
  xorg-twm
  xorg-xclock
  awesome
  vicious
)

sudo pacman -Sy $(mypackages)

# download and install dotfiles
git clone https://github.com/audy/dotflies.git ~/.dotflies
cd ~/.dotflies && ./install

# setup awesome window manager
cp /etc/skel/.xinitrc /home/vagrant
mkdir -p ~/.config
cp /etc/xdg/awesome/rc.lua ~/.config/awesome
