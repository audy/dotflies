# bootstrap script for provisioning my dev environment on a virtual machine
# running Arch

# update all packages
sudo pacman -Syu --noconfirm

mypackages=(
  awesome
  cowsay
  git
  htop
  mesa
  vicious
  vim
  weechat
  wget
  xorg-server
  xorg-server-utils
  xorg-twm
  xorg-xclock
  xorg-xinit
  xterm
)

# install things I want
echo "----> installing packages: "
for package in packages; do
  echo "- installing $(package)"
  echo sudo pacman -Sy "$(package)" > /dev/null
done

# download and install dotfiles
echo "----> downloading dotfiles"
git clone https://github.com/audy/dotflies.git ~/.dotflies > /dev/null
cd ~/.dotflies && FORCE=1 ./install

cowsay "setup complete!"
